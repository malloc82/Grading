;; Main CLI of grading is here :
(in-package :grading)

;; (defmacro check-grade (names)
;;   )

;; (setq id-generator (generator 0))

(defun show-grade (&key (firstname nil) (lastname nil) (title t) (labs t))
  (macrolet ((show (name table)
               `(let ((candidates (getf (gethash ,name ,table) :fullname)))
                  (when candidates
                    (when (and (not (listp labs)) title) (print-title))
                    (loop for student in candidates do
                         (print-grade-student student (gethash student *grade-table*) :labs labs))))))
    (cond ((and firstname lastname)
           (let ((fullname (list :firstname firstname :lastname lastname)))
             (when (gethash fullname *grade-table*)
               (when (and (not (listp labs)) title) (print-title))
               (print-grade-student fullname (gethash fullname *grade-table*) :labs labs))))
          (firstname (show firstname *fname-lut*))
          (lastname (show lastname *lname-lut*))
          (t (format t "No name is given.~%")))))

(defun show-group (&key (id nil) (names nil) (labs t))
  (labels ((show-gid (id)
             (let ((candidates (getf (gethash id *group-table*) :members)))
               (when (not (listp labs)) (print-title))
               (loop for student in candidates do
                    (show-grade :firstname (getf student :firstname)
                                :lastname (getf student :lastname)
                                :title nil :labs labs)))))
    (if id
        (show-gid id)
        (show-gid (choose-group names)))))

(defun select (selections display-fn)
  (let* ((len-1 (1- (length selections)))
         (choice nil))
    
    (format *query-io* "There are more than one machese~%")
    (loop
       for candidate in selections
       for i from 0 to len-1
       do (funcall display-fn i candidate))
    (loop until choice do
         (progn
           (format *query-io* "Please select the correct one: ")                        
           (let ((index (parse-integer (read-line *query-io*) :junk-allowed t)))
             (when (and index (<= index len-1))
               (setq choice (elt selections index))))))
    choice))

(defmacro choose-student (name)
  `(let* ((candidates (append (getf (gethash ,name *fname-lut*) :fullname)
                              (getf (gethash ,name *lname-lut*) :fullname))))
     (if (<= (length candidates) 1)
         (first candidates)
         (select candidates
                 #'(lambda (ith name)
                     (format *query-io* "~d : ~a~%"
                             ith (display-name name)))))))

(defmacro choose-group (name-list)
  `(let ((groups nil))
     (loop for name in ,name-list
        do
          (let* ((name (string-downcase name))
                 (found nil))
            (macrolet ((push-if-found (name table)
                         `(if (getf (gethash ,name ,table) :group-id)
                              (progn
                                (push (getf (gethash name ,table) :group-id) groups)
                                (setq found t)))))
              (push-if-found name *fname-lut*)
              (push-if-found name *lname-lut*))
            (unless found
              (format t "~a is not found in roster." (string-upcase name :start 0 :end 1))
              (return nil)))
        finally (let ((matches (intersection* groups)))
                  (if (null matches)
                      (return nil)
                      (if (> (length matches) 1)
                          (return (select matches
                                          #'(lambda (ith group-id)
                                              (format *query-io* "~d - Group members: ~%" ith)
                                              (loop
                                                 for name in (getf (gethash group-id *group-table*) :members)
                                                 do(format *query-io* "   * ~a~%" (display-name name))
                                                 finally (format *query-io* "~%")))))
                          (return (first matches))))))))

(defmacro set-group-id (fullname gid)
  `(let ((name ,fullname)
         (id ,gid))
     (symbol-macrolet ((group-members (getf (gethash id *group-table*) :members)))
       (setf (getf (gethash name *grade-table*) :group-id) id)
       (if id
           (unless (position name group-members) (push name group-members))
           (setf group-members (delete name group-members)))
       (macrolet ((set-gid (nametag table)
                    `(let ((pos
                            (position
                             name
                             (getf (gethash (getf name ,nametag) ,table) :fullname)
                             :test #'equal)))
                       (setf (elt (getf (gethash (getf name ,nametag) ,table) :group-id) pos) id))))
         (set-gid :firstname *fname-lut*)
         (set-gid :lastname  *lname-lut*)))))

(defun mk-group (name-list)
  (let ((group-members nil))
    (loop for name in name-list
       do
         (let* ((token-list (cl-ppcre:split "\\s*,\\s*" name))
                (fullname (list :firstname (string-downcase (pop token-list))
                                :lastname  (string-downcase (pop token-list)))))
           ;; (format t "~a ~a~%" (getf fullname :firstname) (getf fullname :lastname))
           (symbol-macrolet ((group-id (getf (gethash fullname *grade-table*) :group-id)))
             (if group-id
                 (progn
                   (format t "** ~a is already in group ~d: **~%" name group-id)
                   (list-group-members group-id)
                   (format t "~%")
                   (return nil))
                 (if (gethash fullname *grade-table*)
                     (push fullname group-members)
                     (progn
                       (format t "** ~a is not found in roster. **~%" name)
                       (return nil))))))
         
       finally (when group-members
                 (let* ((id-generator (generator (hash-table-count *group-table*)))
                        (id (funcall id-generator)))
                   (loop while (getf (gethash id *group-table*) :members) do
                        (setq id (funcall id-generator)))
                   (loop for name in group-members do
                        (set-group-id name id)))))))

(defun add-to-group (group-id fullname &key (parse nil))
  (let ((student (if parse (proc-name fullname) fullname)))
    (symbol-macrolet ((record  (gethash student *grade-table*))
                      (curr-id (getf (gethash student *grade-table*) :group-id))
                      (group-members (getf (gethash group-id *group-table*) :members)))
      (if (not record)
          (format t "** Failed. Cannot find record for ~a. **~%" (display-name student))
          (if curr-id
              (if (/= group-id curr-id)
                  (format t "** Failed. ~a is already in group ~d. **~%" (display-name student) group-id)
                  (format t "** ~a is already in this group. **~%" (display-name student)))
              (set-group-id fullname group-id))))))

(defun add-students-to-group (group-id name-list)
  (let ((group-members nil))
    (loop
       for name in name-list do
       (if (atom name)
           (push (choose-student name) group-members)
           (if (gethash name *grade-table*)
               (push name group-members))))
    (loop for student in group-members do
         (set-group-id student group-id))))

(defun remove-from-group (group-id fullname &key (parse nil))
  (let* ((student (if parse (proc-name fullname) fullname))
         (curr-id (getf (gethash student *grade-table*) :group-id)))
    (if (/= curr-id group-id)
        (format t "** ~a does not belongs to this group. **~%" (display-name student))
        (set-group-id fullname nil))))

(defun change-group (group-id fullname &key (parse nil))
  (let ((student (if parse (proc-name fullname) fullname)))
    (symbol-macrolet ((curr-id (getf (gethash student *grade-table*) :group-id)))
      (if (= curr-id group-id)
          (format t "** ~a is already in this group. **~%" (display-name student))
          (progn
            (remove-from-group curr-id student)
            (add-to-group group-id student))))))

(defun set-grade (grade-list &key (firstname nil) (lastname nil))
  (macrolet ((set-grade (name)
               `(let ((fullname ,name))
                  (symbol-macrolet ((lab-entry
                                     (getf (gethash fullname *grade-table*) :lab-grade)))
                    (loop for lab in grade-list
                       do (setf (getf lab-entry (first lab)) (second lab))))))
             (set-grade-name (name table)
               `(let ((match (getf (gethash ,name ,table) :fullname)))
                  (if (= (length match) 1)
                      (set-grade (first match))
                      (set-grade (select match
                                         #'(lambda (ith name)
                                             (format *query-io* "~d : ~a~%"
                                                     ith (display-name name)))))))))
    (cond ((and firstname lastname)
           (set-grade (list :firstname (string-downcase firstname)
                            :lastname  (string-downcase lastname))))
          (firstname (set-grade-name (string-downcase firstname) *fname-lut*))
          (lastname  (set-grade-name (string-downcase lastname)  *lname-lut*))
          (t (format t "No name is given.~%")))))

(defun set-group-grade (name-list grade-list)
  (let ((group-id (choose-group name-list)))
    (if (null group-id)
        (format t "** Could not locate a group that has these students. **")
        (loop for student in (getf (gethash group-id *group-table*) :members) do
             (set-grade grade-list
                        :firstname (getf student :firstname)
                        :lastname  (getf student :lastname))))))


;; (defun list-grades (labs)
;;   (let ((keys nil))
;;     (loop for key being the hash-keys of *grade-table* do
;;          (progn
;;            ;;(format t "~a~%" (display-name key))
;;            (push key keys)))
;;     (setq keys (quicksort-fn keys
;;                              :by  #'(lambda (name)
;;                                       (getf name :firstname))
;;                              :compare> #'string>
;;                              :compare< #'string<
;;                              :compare= #'string=))
;;     (loop for key being the elements of keys do
;;          (progn
;;            (format t "~10a ~16a |" (getf key :firstname) (getf key :lastname))
;;            (loop for lab in labs do
;;                 (format t " ~4,1f" 
;;                         (funcall (mk-symbol "lab-grade-~a" lab)
;;                                  (student-grade (gethash key *grade-table*)))))
;;            (format t "~%")))))
