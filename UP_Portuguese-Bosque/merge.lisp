
(ql:quickload '(:str :cl-conllu :cl-ppcre))

(in-package :cl-conllu)


(defun clean-misc (tk)
  (setf (token-misc tk)
	(format nil "~{~a~^|~}" (remove-if (lambda (e) (equal e "_"))
					   (split-sequence #\|  (token-misc tk))))))


(defun align-sentence (ud up)
  (let ((ud-s (sort ud #'string<= :key #'sentence-id))
	(up-s (sort up #'string<= :key #'sentence-id)))
    (labels ((aux (ud up merged only-ud only-up)
	       (let ((a (car ud))
		     (b (car up)))
		 (cond
		   ((null ud)
		    (values merged only-ud (append up only-up)))
		   ((null up)
		    (values merged (append ud only-ud) only-up))
		   ((equal (sentence-id a) (sentence-id b))
		    (aux (cdr ud) (cdr up) (cons (cons a b) merged) only-ud only-up))
		   ((string< (sentence-id a) (sentence-id b))
		    (aux (cdr ud) up merged (cons a only-ud) only-up))
		   ((string> (sentence-id a) (sentence-id b))
		    (aux ud (cdr up) merged only-ud (cons b only-up)))))))
      (aux ud-s up-s nil nil nil))))


(defun merge-sentences (ud up)
  (let ((res))
    (multiple-value-bind (merged only-ud only-up)
	(align-sentence ud up)
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
			      (format nil "~a|~a|Match=~a~a~a" (token-misc a) (token-misc b)
				      (if (equal (token-upostag a) (token-upostag b)) 1 0)
				      (if (equal (token-head a)    (token-head b))    1 0)
				      (if (equal (token-deprel a)  (token-deprel b))  1 0)))
			(clean-misc a))
		      (sentence-tokens (car p))
		      (sentence-tokens (cdr p)))
	      (push (car p) res)))))))


(defun get-files (directory collection)
  (mapcar (lambda (set)
	    (let ((fn (merge-pathnames directory
				       (make-pathname :name (format nil "pt_bosque-~a-~a" collection set) :type "conllu"))))
	      (assert (probe-file fn))
	      fn))
	  '("dev" "test" "train")))

(defun main (ud-path up-path)
  (let* ((sets (make-hash-table :test #'equal))
	 (up (reduce (lambda (r name)
		       (append r (cl-conllu:read-conllu name)))
		     (get-files up-path "up")
		     :initial-value nil))
	 (ud (reduce (lambda (r name)
		       (let ((sents (cl-conllu:read-conllu name)))
			 (setf (gethash name sets)
			       (mapcar #'sentence-id sents))
			 (append r sents)))
		     (get-files ud-path "ud")
		     :initial-value nil))
	 (db (let ((db (make-hash-table :test #'equal)))
	       (mapc (lambda (s)
		       (setf (gethash (sentence-id s) db) s))
		     (merge-sentences ud up))
	       db)))
    (maphash (lambda (k v)
	       (write-conllu (loop for id in v
				   collect (gethash id db))
			     (make-pathname :name (cl-ppcre:regex-replace "ud" (pathname-name k) "up") :type "conllu.new")))
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


;; (mapcar (lambda (s) (conllu.draw:tree-sentence s :fields-or-function #'format-token))
;; 	(subseq (read-conllu "/Users/ar/work/propbank-release/ud+prop.conllu") 0 10))

