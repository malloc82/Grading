(in-package :grading)

(defun dump-table (table)
  (maphash #'(lambda (key value)
               (format t "~d : ~d~%" key value))
           table))

(defun dump-grade-csv (filename)
  (with-open-file (out filename
                       :direction :output
                       :if-exists :supersede)
    (format out "First name,Surname,Goup,Email")
    (loop for i from 1 to 10 do
         (format out ",lab~d" i))
    (format out "~%")
    (maphash #'(lambda (name entry)
                 (format out "~a,~a"
                         (getf name :firstname)
                         (getf name :lastname))
                 (format out ",~a" (getf entry :group-id))
                 (format out ",~a" (getf entry :email))
                 (loop for (lab grade) on (getf entry :lab-grade) :by #'cddr do
                      (format out ",~a " grade))
                 (format out "~%"))
             *grade-table*)))

(defmacro print-title ()
  `(progn
     (format t "First Name | Last name       |Group| ")
     (loop
        for i from 1 to 10 do
          (format t "~5@a|" (format nil "lab~d" i)))
     (format t "~%~%")))

(defun print-grade-student (name grade-entry &key (labs t) (info nil))
  (format t "~12a ~16a ~4@a |"
          (string-upcase (getf name :firstname) :start 0 :end 1)
          (string-upcase (getf name :lastname) :start 0 :end 1)
          (getf grade-entry :group-id))
  (loop for (key value) on (getf grade-entry :lab-grade) :by #'cddr
     if (listp labs) do
       (when (position key labs :test #'equal)
         (format t " ~5d" value)
         (setq labs (delete key labs :test #'equal)))
     else do 
       (if labs (format t " ~5d" value)))
  (format t "~%"))

(defun print-grade-table (&key (labs t))
  (print-title)
  (maphash #'(lambda (name entry)
               (print-grade-student name entry :labs labs))
           *grade-table*))
