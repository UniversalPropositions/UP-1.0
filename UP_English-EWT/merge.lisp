;; Copyright 2020 IBM

;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at

;;     http://www.apache.org/licenses/LICENSE-2.0

;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

(ql:quickload '(:str :cl-conllu :cl-ppcre))

(defpackage :merge-pb
  (:use :cl :cl-conllu :cl-ppcre))

(in-package :merge-pb)

;; utilities

(defun token-misc-alist (tk)
  (mapcar (lambda (p)
	    (let ((pair (str:split #\= p)))
	      (ecase (length pair)
		(2 (cons (car pair) (cadr pair)))
		(1 (cons (car pair) nil)))))
	  (str:split #\| (token-misc tk))))

(defun alist-update (alist key value &optional (test #'equal))
  "Update the value of a key or add a cell."
  (let ((cell (assoc key alist :test test)))
    (if cell
        (progn (setf (cdr cell) value) alist)
        (acons key value alist))))

(defun update-token-misc (tk alist)
  (setf (token-misc tk)
	(format nil "~{~a~^|~}"
		(mapcar (lambda (e)
			  (if (cdr e)
			      (format nil "~a=~a" (car e) (cdr e))
			      (format nil "~a" (car e))))
			alist))))

(defun clean-misc (tk &optional (fields nil))
  (let ((alist (remove '("_") (token-misc-alist tk) :test #'equal)))
    (loop for fld in fields
	  do (setq alist (remove fld alist :test #'equal :key #'car)))
    (update-token-misc tk alist)))


(defun extract-token-misc (s field)
  (mapcar (lambda (tk)
	    (cdr (assoc field (token-misc-alist tk) :test #'equal)))
	  (sentence-tokens s)))



;; main code

(defun ud-id (s)
  (let ((doc (sentence-meta-value s "doc_id"))
	(pid (format nil "~4,'0d" (1+ (parse-integer (sentence-id s))))))
    (register-groups-bind (group fname)
	("google/ewt/([a-z]+)/00/([^-]+)\\.xml" doc :sharedp t)
      (format nil "~a-~a-~a" group fname pid))))


(defun align-sentences (ud up)
  (let ((ud-s (sort ud #'string<= :key #'sentence-id))
	(up-s (sort up #'string<= :key #'ud-id)))
    (labels ((aux (ud up merged only-ud only-up)
	       (let ((a (car ud))
		     (b (car up)))
		 (cond
		   ((null ud)
		    (values merged only-ud (append up only-up)))
		   ((null up)
		    (values merged (append ud only-ud) only-up))
		   ((equal (sentence-id a) (ud-id b))
		    (aux (cdr ud) (cdr up) (cons (cons a b) merged) only-ud only-up))
		   ((string< (sentence-id a) (ud-id b))
		    (aux (cdr ud) up merged (cons a only-ud) only-up))
		   ((string> (sentence-id a) (ud-id b))
		    (aux ud (cdr up) merged only-ud (cons b only-up)))))))
      (aux ud-s up-s nil nil nil))))


(defun merge-sentences (ud up)
  (let ((res))
    (multiple-value-bind (merged only-ud only-up)
	(align-sentences ud up)
      (dolist (p only-ud)
	(push '("propbank" . "no-up") (sentence-meta p))
	(push p res))
      (dolist (p only-up)
	(push '("propbank" . "not-in-ud") (sentence-meta p))
	(push p res))
      (dolist (p merged res)
	(if (not (equal (length (sentence-tokens (car p)))
			(length (sentence-tokens (cdr p)))))
	    (progn
	      (push '("propbank" . "diff-number-tokens") (sentence-meta (car p)))
	      (push (car p) res))
	    (progn
	      (mapcar (lambda (a b)
			(setf (token-misc a)
			      (format nil "~{~a~^|~}"
				      (list (token-misc a)
					    (token-misc b)
					    (if (equal (token-xpostag a) (token-upostag b))
						"_"
						(format nil "PTBPOS=~a" (token-upostag b))))))
			(clean-misc a))
		      (sentence-tokens (car p))
		      (sentence-tokens (cdr p)))
	      (push (car p) res)))))))


(defun parse-args (alist)
  (labels ((tk-type (s)
	     (let ((cpat "^\\(([^()]+)\\*\\)$")
		   (ipat "^\\(([^()]+)\\*$"))
	       (cond
		 ((equal s "*")  (cons :star nil))
		 ((equal "*)" s) (cons :end nil))
		 ((cl-ppcre:scan-to-strings cpat s)
		  (multiple-value-bind (m r)
		      (cl-ppcre:scan-to-strings cpat s)
		    (declare (ignore m))
		    (cons :complete (aref r 0))))
		 ((cl-ppcre:scan-to-strings ipat s)
		  (multiple-value-bind (m r)
		      (cl-ppcre:scan-to-strings ipat s)
		    (declare (ignore m))
		    (cons :ini (aref r 0))))
		 (t (error "non-expected token [~a]!" s)))))
	   (aux (alist pos curr res)
	     (if (null alist)
		 (reverse res)
		 (let ((tk (car alist)))
		   (ecase (car (tk-type tk))
		     (:star
		      (aux (cdr alist) (1+ pos) curr res))
		     (:end
		      (aux (cdr alist) (1+ pos) nil (cons (list (car curr) (cdr curr) pos) res)))
		     (:ini
		      (aux (cdr alist) (1+ pos) (cons (cdr (tk-type tk)) pos) res))
		     (:complete
		      (aux (cdr alist) (1+ pos) nil (cons (list (cdr (tk-type tk)) pos pos) res))))))))
    (aux alist 0 nil nil)))


(defun span-head (s ini-p end-p)
  (let ((all-tokens (sentence-tokens s)))
    (labels ((get-token-head (tk)
	       (nth (1- (token-head tk)) all-tokens))
	     (aux (tks heads)
	       (cond
		 ((null tks)
		  (remove-duplicates heads :key #'token-id :test #'equal))

		 ((equal (token-head (car tks)) 0)
		  (aux (cdr tks) (cons (car tks) heads)))

		 ((<= ini-p (1- (token-head (car tks))) end-p)
		  (aux (cons (get-token-head (car tks)) (cdr tks)) heads))

		 (t (aux (cdr tks) (cons (car tks) heads))))))
      (aux (subseq (sentence-tokens s) ini-p (1+ end-p)) nil))))


(defun srl-sentence (s)
  (let* ((preds  (remove-if (lambda (p) (or (null (cdr p)) (equal "-" (cdr p))))
			    (mapcar #'cons
				    (sentence-tokens s)
				    (extract-token-misc s "Roleset"))))
	 (args   (make-array (list 2 (length (sentence-tokens s)) (length preds))
			     :initial-element nil)))

    (when preds
      (destructuring-bind (i rt ct)
	  (array-dimensions args)
	(declare (ignore i))
	(let ((vls (extract-token-misc s "Args")))
	  (assert (equal (length vls) rt))
	  (loop for rv in vls
		for ri from 0 below rt
		do (loop for cv in (str:split #\/ rv)
			 for ci from 0 below ct
			 do (assert (equal (length (str:split #\/ rv)) ct)
				    (rt ct rv cv)
				    "rt = ~s  ct = ~s rv = ~s cv = ~s" rt ct rv cv)
			 do (setf (aref args 0 ri ci) cv))))

	(dotimes (c ct)
	  (mapc (lambda (a)
		  (let* ((heads (span-head s (cadr a) (caddr a))))
		    ;; (assert (equal (length heads) 1))
		    (dolist (head heads)
		      (setf (aref args 1 (1- (token-id head)) c)
			    (car a)))))
		(parse-args (loop for r from 0 below rt collect (aref args 0 r c)))))

	(loop for tk in (sentence-tokens s)
	      do (let ((al (token-misc-alist tk))
		       (vs (loop for c from 0 below ct collect (or (aref args 1 (1- (token-id tk)) c) "_"))))
		   (update-token-misc tk
				      (alist-update al "Args" (format nil "~{~a~^/~}" vs)))))))))


(defun main ()
  (let* ((sets (make-hash-table :test #'equal))
	 (up   (cl-conllu:read-conllu "propbank-all.conllu"))
	 (ud   (reduce (lambda (r fn)
			 (let ((sents (cl-conllu:read-conllu fn)))
			   (setf (gethash fn sets)
				 (mapcar #'sentence-id sents))
			   (append r sents)))
		       (list #P"/Users/ar/work/ud-english-ewt/en_ewt-ud-dev.conllu"
			     #P"/Users/ar/work/ud-english-ewt/en_ewt-ud-test.conllu"
			     #P"/Users/ar/work/ud-english-ewt/en_ewt-ud-train.conllu")
		       :initial-value nil))
	 (db   (make-hash-table :test #'equal)))
    (mapc (lambda (s)
	    (setf (gethash (sentence-id s) db) s))
	  (mapc #'srl-sentence (merge-sentences ud up)))
    (maphash (lambda (k v)
	       (write-conllu (loop for id in v collect (gethash id db :error))
			     (make-pathname :name (cl-ppcre:regex-replace "ud" (pathname-name k) "up")
					    :type "conllu.new")))
	     sets)))


;; for use with conllu.draw:tree-sentence function
(defun format-token (tk)
  (let ((args (cadr (assoc "Args"  
			   (mapcar (lambda (e) (str:split #\= e))
				   (str:split #\| (token-misc tk)))
			   :test #'equal))))
    (format nil "~a ~a ~a  ~a" 
	    (token-form tk)
	    (token-upostag tk)
	    (token-deprel tk)
	    (cl-ppcre:regex-replace "(\\*/?)+$" args ""))))

