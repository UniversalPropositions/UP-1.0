
(ql:quickload '(:str :cl-conllu :cl-ppcre))

(in-package :cl-conllu)


(defun ud-table (sents)
  (let ((tb (make-hash-table :test #'equal)))
    (dolist (s sents tb)
      (if (gethash (sentence-id s) tb)
	  (error "not possible ~s" (sentence-id s))
	  (setf (gethash (sentence-id s) tb)
		s)))))

(defun match-sentences (ud pb)
  (let ((tb (ud-table ud))
	(missing nil))
    (dolist (p pb (values tb missing))
      (let ((doc (sentence-meta-value p "doc_id"))
	    (pid (format nil "~4,'0d" (1+ (parse-integer (sentence-id p))))))
	(register-groups-bind (group fname)
	    ("google/ewt/([a-z]+)/00/([^-]+)\\.xml" doc :sharedp t)
	  (let ((nid (format nil "~a-~a-~a" group fname pid)))
	    (if (gethash nid tb)
		(setf (gethash nid tb)
		      (cons (gethash nid tb) p))
		(push p missing))))))))


(defun missing-sentences (ud pb)
  (loop for value being the hash-values of (match-sentences ud pb)
	  using (hash-key key)
	do (if (not (consp value))
	       (format t "- ~a : ~a~%" key (sentence-text value)))))


(defun diff-number-of-tokens (ud pb)
  (loop for v being the hash-values of (match-sentences ud pb) using (hash-key k)
	when (and (consp v) 
		  (not (equal (length (sentence-tokens (car v)))
			      (length (sentence-tokens (cdr v)))))) 
	  collect v))


(defun clean-misc (tk)
  (setf (token-misc tk)
	(format nil "~{~a~^|~}" (remove-if (lambda (e) (equal e "_"))
					   (split-sequence #\|  (token-misc tk))))))


(defun merge-sentences (ud pb)
  (let ((res nil))
    (dolist (p (alexandria:hash-table-alist (match-sentences ud pb)) (reverse res))
      (cond
	((not (consp (cdr p)))
	 (push '("propbank" . "no-srl") (sentence-meta (cdr p)))
	 (push (cdr p) res))

	((not (equal (length (sentence-tokens (cadr p)))
		     (length (sentence-tokens (cddr p)))))
	 (push '("propbank" . "diff-number-tokens") (sentence-meta (cadr p)))
	 (push (cadr p) res))

	(t  (mapcar (lambda (a b)
		      (setf (token-misc a)
			    (format nil "~a|Tree=~a|~a~a" (token-misc a) (token-deps b) (token-misc b)
				    (if (equal (token-xpostag a) (token-upostag b))
					""
					(format nil "|PBPOS=~a" (token-upostag b)))))
		      (clean-misc a))
		    (sentence-tokens (cadr p))
		    (sentence-tokens (cddr p)))
	    (push (cadr p) res))))))


(defun main ()
  (let ((pb (cl-conllu:read-conllu "en-ewt.conllu"))
	(ud (reduce (lambda (r name)
		      (append r (cl-conllu:read-conllu name)))
		    '("~/work/ud-english-ewt/en_ewt-ud-dev.conllu"
		      "~/work/ud-english-ewt/en_ewt-ud-test.conllu"
		      "~/work/ud-english-ewt/en_ewt-ud-train.conllu")
		    :initial-value nil)))
    (conllu-write (mapc (lambda (s)
			  (dolist (tk (sentence-tokens s))
			    (setf (token-deps tk) "_")))
			(merge-sentences ud pb)) #P"ud+prop.conllu")))



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

