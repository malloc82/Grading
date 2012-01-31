;; Utilities function

(in-package :grading)

(defun generator (init)
  (let ((counter init))
    #'(lambda ()
        (let ((ret counter))
          (setq counter (1+ counter))
          ret))))

(defun quicksort-fn (lst &key (by #'values) (compare< #'<) (compare> #'>) (compare= #'-))
  (if (or (null lst)
          (null (cdr lst)))
      lst
      (let ((pivot (funcall by (first lst))))
        (append (quicksort-fn (remove-if-not #'(lambda (x)
                                                 (funcall compare< (funcall by x) pivot))
                                             lst) :by by :compare< compare< :compare> compare>
                                             :compare= compare=)
                (remove-if-not #'(lambda (x) (funcall compare= (funcall by x) pivot)) lst)
                (quicksort-fn (remove-if-not #'(lambda (x)
                                                 (funcall compare> (funcall by x) pivot))
                                             lst) :by by :compare< compare< :compare> compare>
                                             :compare= compare=)))))

(defmacro display-name (fullname)
  `(let ((name ,fullname))
     (concatenate 'string
                  (string-upcase (getf name :firstname) :start 0 :end 1)
                  " "
                  (string-upcase (getf name :lastname)  :start 0 :end 1))))

(defmacro proc-name (fullname)
  `(list :firstname (string-downcase (getf ,fullname :firstname))
         :lastname  (string-downcase (getf ,fullname :lastname))))

(defmacro intersection* (lists)
  `(let ((lists  (cdr ,lists))
         (result (first ,lists)))
     (loop until (or (null result) (null lists)) do
          (setq result (intersection result (pop lists))))
     result))

(defmacro set-if-not-in (val field)
  `(let ((value ,val))
     (unless (position value ,field)
       (push value ,field))))

(defmacro list-group-members (id)
  `(let ((name-list (getf (gethash ,id *group-table*) :members)))
     (loop for name in name-list do
          (format t "  ~a~%" (display-name name)))))
