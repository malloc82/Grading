(use-package :cl-ppcre)

(defvar *grade-table* (make-hash-table :test #'equal))
(defvar *fname-lut* (make-hash-table :test #'equal))
(defvar *lname-lut* (make-hash-table :test #'equal))
(defvar *group-table* (make-hash-table :test #'equal))

(defun test-reset (&key (dump nil))
  "This function is used for testing. It will reset all the tables, reload default data."
  (setq *grade-table* (make-hash-table :test #'equal))
  (setq *fname-lut*   (make-hash-table :test #'equal))
  (setq *lname-lut*   (make-hash-table :test #'equal))
  (setq *group-table* (make-hash-table :test #'equal))
  (import-name-list "~/Downloads/CSE310-01F11_Grades.txt")
  (mapc #'mk-group
        '(("Jeremiah, Lukacs" "Albert,Banuelos")
          ("Cory, Cook" "Roman,Ruiz" "Corey,Lunt")
          ("Douglas,Duncan" "Jessica,Brown")
          ("Edward,Munoz III" "Guillermo,Garcia Jr")
          ("Bryan,Johnson" "Taylor,Sanchez" "Diego,Bernal")
          ("Johnny,Nguyen" "David,Smit" "Jonathan,Carranza")
          ("Manuel,Del Rio" "Christina,Torres")
          ("Andrew,Davis" "Eugene,Chandler")
          ("Maurice,Njuguna" "Mac,Chou")
          ("Paul,Cummings" "Gustavo,Cruz")
          ("La,Van Doren Jr" "Darin,Truckenmiller")
          ("Ran,Wei" "Muhammad,Ali")

          ("Viviane,Helmig" "Roman,Savilov" "Abigail,Farrier")
          ("Anthony,Phillips" "Theodore,Phillips II" "Aminul,Hasan")
          ("Evan,Casey" "Ngan,Do" "Kyle,Johnson")
          ("Michael,Shabsin" "Nikolay,Figurin")
          ;; ("Lavern,Slusher Jr" "Michael,Korcha I" "Garrett,Albers")
          ;; ("Jeffrey,Carter" "Henry,Gomez" "Dennis,Zamora")
          ("Bryan,Amann" "Sean,Finucane" "Peter,Diaz III")
          ("Ahmed,Kamel" "Dylan,Allbee" "Ryan,Stegmann")
          ("Kanika,Bhat" "Francisco,Ron" "Janette,Rodriguez")
          ("Carlos,Gomez Viramontes" "Ryan,Rady")
          ("Henry,Johnson" "Dillon,Li" "Michael,Schenk")
          ("Joey,Cantellano" "Abraham,Flores Jr")))
  (if dump (print-grade-table)))

(defun dump-table (table)
  (maphash #'(lambda (key value)
               (format t "~d : ~d~%" key value))
           table))

(defun dump-grade-csv ()
  (maphash #'(lambda (key value)
               (format t "~a,~a"
                       (string-upcase (getf key :firstname) :start 0 :end 1)
                       (string-upcase (getf key :lastname) :start 0 :end 1))
               (loop for (key value) on (getf value :lab-grade) :by #'cddr
                  do (format t ",~a" value))
               (format t "~%"))
           *grade-table*))

(defun print-grade-table ()
  (maphash #'(lambda (key value)
               (format t "~10a ~16a ~5a"
                       (string-upcase (getf key :firstname) :start 0 :end 1)
                       (string-upcase (getf key :lastname) :start 0 :end 1)
                       (getf value :group-id))
               (loop for (key value) on (getf value :lab-grade) :by #'cddr
                    do (format t " ~3d" value))
               (format t "~%"))
           *grade-table*))

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

(defmacro check-grade (names)
  )

(defun generator (init)
  (let ((counter init))
    #'(lambda ()
        (let ((ret counter))
          (setq counter (1+ counter))
          ret))))

;; (setq id-generator (generator 0))

(defun import-name-list (filename)
  (with-open-file (fin filename
                       :direction :input)
    (let ((titles nil)
          (firstname-index nil)
          (lastname-index nil)
          (email-index nil))
      (do ((line (read-line fin nil)
                 (read-line fin nil)))
          ((null line))
        (let ((token-list (cl-ppcre:split "," line)))
          (if (null titles)
              (loop
                 for token in token-list
                 for i from 0 to (1- (length token-list))
                 do (cond ((equal token "First name") (setq firstname-index i))
                          ((equal token "Surname") (setq lastname-index i))
                          ((equal token "Email address") (setq email-index i)))
                 finally (setq titles t))
              (let* ((firstname (string-downcase (elt token-list firstname-index)))
                     (lastname  (string-downcase (elt token-list lastname-index)))
                     (email     (elt token-list email-index))
                     (fullname  (list :firstname firstname :lastname lastname)))

                (symbol-macrolet ((table-entry  (gethash fullname  *grade-table*))
                                  (lname-entry  (getf (gethash lastname  *lname-lut*) :fullname))
                                  (fname-entry  (getf (gethash firstname *fname-lut*) :fullname)))
                  (setf (getf table-entry :lab-grade) (list :lab1  0
                                                            :lab2  0
                                                            :lab3  0
                                                            :lab4  0
                                                            :lab5  0
                                                            :lab6  0
                                                            :lab7  0
                                                            :lab8  0
                                                            :lab9  0
                                                            :lab10 0))
                  (setf (getf table-entry :email) email)
                  (if (not (position fullname lname-entry :test #'equal)) (push fullname lname-entry))
                  (if (not (position fullname fname-entry :test #'equal)) (push fullname fname-entry))
                  ;; (format t "~a, ~a : ~a~%" firstname lastname email)
                  ))))))))

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
                   (loop while (gethash id *group-table*) do
                        (setq id (funcall id-generator)))
                   (setf (getf (gethash id *group-table*) :members) group-members)
                   (loop for name in group-members do
                        (setf (getf (gethash name *grade-table*) :group-id) id)
                        (macrolet ((push-id (nametag table)
                                     `(unless (position name (getf (gethash (getf name ,nametag) ,table) :fullname))
                                       (push id (getf (gethash (getf name ,nametag) ,table) :group-id)))))
                          (push-id :firstname *fname-lut*)
                          (push-id :lastname  *lname-lut*))))))))

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
              (progn
                (setf curr-id group-idd)
                (push group-id (getf (gethash (getf student :firstname) *fname-lut*) :group-id))
                (push group-id (getf (gethash (getf student :lastname) *lname-lut*) :group-id))
                (push student group-members)))))))

(defun add-students-to-group (group-id name-list)
  (mapc #'(lambda (name)
            (let ((candidates nil))
              (if (atom name)
                  (setq candidates
                        (append (getf (gethash (string-downcase name) *fname-lut*) :fullname)
                                (getf (gethash (string-downcase name) *lname-lut*) :fullname)))
                  (setq candidates (list name)))
              (print candidates)
              (loop for student in candidates do
                   (add-to-group group-id student))))
        name-list))

(defun short-name-lookup (name-list &key ())
  )

(defun remove-from-group (group-id fullname &key (parse nil))
  (let ((student (if parse (proc-name fullname) fullname)))
    
    (symbol-macrolet ((curr-id            (getf (gethash student *grade-table*) :group-id))
                      (member-list        (getf (gethash group-id *group-table*) :members))
                      (firstname-group-id (getf (gethash (getf student :firstname) *fname-lut*) :group-id))
                      (lastname-group-id  (getf (gethash (getf student :lastname) *lname-lut*) :group-id)))
      (if (/= curr-id group-id)
          (format t "** ~a does not belongs to this group. **~%" (display-name student))
          (progn
            (setf curr-id nil)
            (setf firstname-group-id (delete group-id firstname-group-id))
            (setf lastname-group-id (delete group-id lastname-group-id))
            (setf member-list (delete student member-list :test #'equal)))))))

(defun change-group (group-id fullname &key (parse nil))
  (let ((student (if parse (proc-name fullname) fullname)))
    (symbol-macrolet ((curr-id (getf (gethash student *grade-table*) :group-id)))
      (if (= curr-id group-id)
          (format t "** ~a is already in this group. **~%" (display-name student))
          (progn
            (remove-from-group curr-id student)
            (add-to-group group-id student))))))

(defun select (selections display)
  (let* ((len-1 (1- (length selections)))
         (choice nil))
    
    (format *query-io* "There are more than one machese~%")
    (loop
       for candidate in selections
       for i from 0 to len-1
       do (funcall display i candidate))
    (loop until choice do
         (progn
           (format *query-io* "Please select the correct one: ")                        
           (let ((index (parse-integer (read-line *query-io*) :junk-allowed t)))
             (when (and index (<= index len-1))
               (setq choice (elt selections index))))))
    choice))

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

(defun set-group-grade (grade-list name-list)
  (let ((groups nil))
    (loop for name in name-list
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
                     (progn
                       (format t "Cannot find a group with given names~%")
                       (return nil))
                     (let ((group-id (if (> (length matches) 1)
                                         (select matches
                                                 #'(lambda (ith group-id)
                                                     (format *query-io* "~d - Group members: ~%" ith)
                                                     (loop
                                                        for name in (getf (gethash group-id *group-table*) :members)
                                                        do(format *query-io* "   * ~a~%" (display-name name))
                                                        finally (format *query-io* "~%"))))
                                              (first matches))))
                       (loop for student in (getf (gethash group-id *group-table*) :members) do
                            (set-grade grade-list
                                       :firstname (getf student :firstname)
                                       :lastname  (getf student :lastname)))))))))

(defun dump-grade (filename)
  (with-open-file (out filename
                       :direction :output
                       :if-exists :supersede)
    (maphash #'(lambda (key value)
                 (format out "~a : ~s~%" key value)
                 (format t "~a : ~s~%" key value))
             *grade-table*)))

(defun load-grade (filename)
  (with-open-file (in filename
                      :direction :input)
    (setq *grade-table* (make-hash-table :test #'equal))
    (do ((line (read-line in nil)
               (read-line in nil)))
        ((null line))
      (let ((key-value (cl-ppcre:split "\\s*:\\s*" line)))
        ;; (setf (gethash (first key-value) *grade-table*) (second key-value))
        (format t "~a : ~a | ~%" (first key-value) (second key-value))))))

(defun macrolet-test (x y)
  (macrolet ((m2 (x y)
               `(progn
                  (m1 ,x)
                  (m1 ,y)))
             (m1 (x)
               `(format t "~a, ~a ~%" ,x x)))
    (m2 y x)))

(defun import-grade (file))
