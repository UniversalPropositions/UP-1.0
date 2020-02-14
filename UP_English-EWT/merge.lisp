
(ql:quickload '(:str :cl-conllu :cl-ppcre))

(in-package :cl-conllu)


(defun clean-misc (tk)
  (setf (token-misc tk)
	(format nil "~{~a~^|~}" (remove-if (lambda (e) (equal e "_"))
					   (split-sequence #\|  (token-misc tk))))))


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
			      (format nil "~a|Tree=~a|~a~a" (token-misc a) (token-deps b) (token-misc b)
				      (if (equal (token-xpostag a) (token-upostag b))
					  ""
					  (format nil "|PBPOS=~a" (token-upostag b)))))
			(clean-misc a))
		      (sentence-tokens (car p))
		      (sentence-tokens (cdr p)))
	      (push (car p) res)))))))



(defun extract-token-misc (s field)
  (mapcar (lambda (tk)
	    (cadr (assoc field (mapcar (lambda (p) (str:split #\= p))
				       (str:split #\| (token-misc tk)))
			 :test #'equal)))
	  (sentence-tokens s)))


(defun parse-args (alist)
  (labels ((tk-type (s)
	     (let ((cpat "^\\(([^()]+)\\)$")
		   (ipat "^\\(([^()]+)$"))
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
		   (case (car (tk-type tk))
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
      (aux (subseq (sentence-tokens s) ini-p (1+ end-p)) nil)))))


(defun srl-sentence (s)
  (let ((preds  (remove-if (lambda (p) (equal "-" (cdr p)))
			   (mapcar #'cons
				   (sentence-tokens s)
				   (extract-token-misc s "Roleset"))))
	(res))
    (when preds
      (let ((args-m (make-array (list (length (sentence-tokens s)) (length preds))
				:element-type 'string
				:initial-contents
				(mapcar (lambda (v) (str:split #\/ v))
					(extract-token-misc s "Args"))))) 
	(destructuring-bind (n m)
	    (array-dimensions args-m)
	  (dotimes (c m res)
	    (push (list (car (nth c preds))
			(cdr (nth c preds))
			(mapcar (lambda (a) (list (car a) (span-head s (cadr a) (caddr a))))
				(parse-args (loop for i from 0 below n collect (aref args-m i c)))))
		 res)))))))


(defun test ()
  (let ((up (cl-conllu:read-conllu "en-ewt.conllu"))
	(ud (reduce (lambda (r fn)
		      (let ((sents (cl-conllu:read-conllu fn)))
			(append r sents)))
		    (list #P"/Users/ar/work/ud-english-ewt/en_ewt-ud-dev.conllu"
			  #P"/Users/ar/work/ud-english-ewt/en_ewt-ud-test.conllu"
			  #P"/Users/ar/work/ud-english-ewt/en_ewt-ud-train.conllu")
		    :initial-value nil)))
    (merge-sentences ud up)))


(defun main ()
  (let* ((sets (make-hash-table :test #'equal))
	 (up (cl-conllu:read-conllu "en-ewt.conllu"))
	 (ud (reduce (lambda (r fn)
		       (let ((sents (cl-conllu:read-conllu fn)))
			 (setf (gethash fn sets)
			       (mapcar #'sentence-id sents))
			 (append r sents)))
		     (list #P"/Users/ar/work/ud-english-ewt/en_ewt-ud-dev.conllu"
			   #P"/Users/ar/work/ud-english-ewt/en_ewt-ud-test.conllu"
			   #P"/Users/ar/work/ud-english-ewt/en_ewt-ud-train.conllu")
		     :initial-value nil))
	 (db (make-hash-table :test #'equal)))
    (mapc (lambda (s)
	    (setf (gethash (sentence-id s) db) s))
	  (merge-sentences ud up))
    (maphash (lambda (k v)
	       (write-conllu (loop for id in v collect (gethash id db :error))
			     (make-pathname :name (cl-ppcre:regex-replace "ud" (pathname-name k) "up")
					    :type "conllu.new")))
	     sets)))



(defun format-token (tk)
  (let ((args (cadr (assoc "Args"  
			   (mapcar (lambda (e) (split-sequence #\= e))
				   (split-sequence #\| (token-misc tk)))
			   :test #'equal))))
    (format nil "~a ~a ~a  ~a" 
	    (token-form tk)
	    (token-upostag tk)
	    (token-deprel tk)
	    (cl-ppcre:regex-replace "(\\*/?)+$" args ""))))


(mapcar (lambda (s) (conllu.draw:tree-sentence s :fields-or-function #'format-token))
	(subseq (read-conllu "/Users/ar/work/propbank-release/ud+prop.conllu") 0 10))

