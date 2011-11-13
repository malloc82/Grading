(use-package :cl-ppcre)


(defvar *grade-table* (make-hash-table :test #'equal))
(defstruct fullname
  (first "NONAME" :type string :read-only t)
  (last  "NONAME" :type string :read-only t))

(defstruct lab-grade
  (lab1  0.0 :type short-float)
  (lab2  0.0 :type short-float)
  (lab3  0.0 :type short-float)
  (lab4  0.0 :type short-float)
  (lab5  0.0 :type short-float)
  (lab6  0.0 :type short-float)
  (lab7  0.0 :type short-float)
  (lab8  0.0 :type short-float)
  (lab9  0.0 :type short-float)
  (lab10 0.0 :type short-float))

(defstruct student
  (name  (make-fullname)  :type fullname)
  (grade (make-lab-grade) :type lab-grade)
  (gid   0                :type integer)
  (email ""               :type string))

(defvar *fname-lut* (make-hash-table :test #'equal))
(defvar *lname-lut* (make-hash-table :test #'equal))
(defstruct lookup-entry
  (groups   nil :type list)
  (students nil :type list))

(defvar *group-table* (make-hash-table :test #'equal))

(defun test-reset (&key (dump nil))
  "This function is used for testing. It will reset all the tables, reload default data."
  (setq *grade-table* (make-hash-table :test #'equal))
  (setq *fname-lut*   (make-hash-table :test #'equal))
  (setq *lname-lut*   (make-hash-table :test #'equal))
  (setq *group-table* (make-hash-table :test #'equal))
  (import-name-list "~/Downloads/CSE310-01F11_Grades.txt")
  (mapc #'mk-group
        '(("Jeremiah, Lukacs" "Albert,Banuelos") ;; :lab4 10; :lab5 10; :lab8, bcd finished in lab
          ("Cory, Cook" "Roman,Ruiz" "Corey,Lunt") ;; :lab4 7, no source & diagram; :lab5 8, missing timing
          ("Douglas,Duncan" "Jessica,Brown") ;; :lab4 10; :lab5 10; 
          ("Edward,Munoz III" "Guillermo,Garcia Jr") ;; 
          ("Bryan,Johnson" "Taylor,Sanchez" "Diego,Bernal") ;;
          ("Johnny,Nguyen" "David,Smit" "Jonathan,Carranza") ;; 
          ("Manuel,Del Rio" "Christina,Torres") ;; 
          ("Andrew,Davis" "Eugene,Chandler") ;; 
          ("Maurice,Njuguna" "Mac,Chou") ;; lab5 , no source & diagram; 
          ("Paul,Cummings" "Gustavo,Cruz") ;; lab5, incomplete source
          ("La,Van Doren Jr" "Darin,Truckenmiller") ;;
          ("Ran,Wei" "Muhammad,Ali") ;; 

          ("Viviane,Helmig" "Roman,Savilov" "Abigail,Farrier") ;; 
          ("Anthony,Phillips" "Theodore,Phillips II" "Aminul,Hasan") ;; 
          ("Evan,Casey" "Ngan,Do" "Kyle,Johnson");; 
          ("Michael,Shabsin" "Nikolay,Figurin") ;; 
          ("Lavern,Slusher Jr" "Michael,Korcha I" "Garrett,Albers") ;; 
          ("Jeffrey,Carter" "Henry,Gomez" "Dennis,Zamora") ;; 
          ("Bryan,Amann" "Sean,Finucane" "Peter,Diaz III") ;; 
          ("Ahmed,Kamel" "Dylan,Allbee" "Ryan,Stegmann") ;; 
          ("Kanika,Bhat" "Francisco,Ron" "Janette,Rodriguez") ;;  :lab 8, working
          ("Carlos,Gomez Viramontes" "Ryan,Rady") ;; 
          ("Henry,Johnson" "Dillon,Li" "Michael,Schenk") ;; 
          ("Joey,Cantellano" "Abraham,Flores Jr"))) ;; 
  
  (set-group-grade '("jeremiah" "albert")
                   '((:lab1 6) (:lab4 10) (:lab5 10)))
  (set-group-grade '("cory" "roman")
                   '((:lab1 6) (:lab4 7) (:lab5 8)))
  (set-group-grade '("duncan" "jessica")
                   '((:lab4 10) (:lab5 10)))
  (set-group-grade '("edward" "guillermo")
                   '((:lab1 6) (:lab4 10) (:lab5 10)))
  (set-group-grade '("bryan" "taylor")
                   '((:lab1 6) (:lab4 10) (:lab5 10) ))
  (set-group-grade '("johnny" "david")
                   '((:lab4 10) (:lab5 10)))
  (set-group-grade '("manuel" "torres")
                   '((:lab4 8) (:lab5 10)))
  (set-group-grade '("andrew" "eugene")
                   '((:lab4 10) (:lab5 10)))
  (set-group-grade '("maurice" "chou")
                   '((:lab1 6) (:lab4 8) (:lab5 5)))
  (set-group-grade '("paul" "Gustavo")
                   '((:lab4 10) (:lab5 9)))
  (set-group-grade '("la" "darin")
                   '((:lab4 8) (:lab5 10)))
  (set-group-grade '("ran" "ali")
                   '((:lab1 5) (:lab4 10) (:lab5 10) ))

  (set-group-grade '("viviane" "roman")
                   '((:lab5 8) (:lab6 10)))
  (set-group-grade '("phillips" "hasan")
                   '((:lab5 8)  (:lab5 8)))
  (set-group-grade '("evan" "ngan")
                   '((:lab6 7)  (:lab5 9)))
  (set-group-grade '("michael" "nikolay")
                   '((:lab4 6) (:lab5 5) (:lab6 6)))
  (set-group-grade '("lavern" "michael")
                   '((:lab5 8) (:lab6 8)))
  (set-group-grade '("jeffrey" "henry")
                   '((:lab5 6) (:lab6 7)))
  (set-group-grade '("bryan" "sean")
                   '((:lab5 10) (:lab6 10)))
  (set-group-grade '("ahmed" "dylan")
                   '((:lab4 8) (:lab5 10) (:lab6 10)))
  (set-group-grade '("kanika" "ron")
                   '((:lab5 8) (:lab6 8)))
  (set-group-grade '("carlos" "ryan")
                   '((:lab5  10) (:lab6 10)))
  (set-group-grade '("henry" "dillon")
                   '((:lab5 10) (:lab6 10)))
  (set-group-grade '("joey" "abraham")
                   '((:lab5 8) (:lab6 10)))
  (if dump (print-grade-table)))

(defmacro mk-symbol (format sym)
  `(read-from-string (format nil ,format ,sym)))

(defun dump-table (table)
  (maphash #'(lambda (key value)
               (format t "~16a : ~a~%" key value))
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
  (maphash #'(lambda (name value)
               (format t "~10a ~16a ~3d |"
                       (string-upcase (getf name :firstname) :start 0 :end 1)
                       (string-upcase (getf name :lastname)  :start 0 :end 1)
                       (student-gid value))
               (let ((grade (student-grade value)))
                 (loop for i from 1 to 10 do
                      (format t " ~4,1f"
                              (funcall (read-from-string (format nil "lab-grade-lab~d" i)) grade))))
               (format t "~%"))
           *grade-table*))

(defmacro display-name (name)
  `(let ((name ,name))
     (concatenate 'string
                  (string-upcase (getf name :firstname) :start 0 :end 1)
                  " "
                  (string-upcase (getf name :lastname)  :start 0 :end 1))))

(defmacro proc-name (name-str)
  `(list :firstname (string-downcase (getf ,name-str :firstname))
         :lastname  (string-downcase (getf ,name-str :lastname))))

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
  `(let ((name-list (if (gethash ,id *group-table*)
                        (group-members (gethash ,id *group-table*))
                        nil)))
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
                     (student (make-student
                               :name (make-fullname :first firstname :last  lastname)
                               :grade (make-lab-grade)
                               :email (elt token-list email-index)))
                     (std-name (list :firstname firstname :lastname lastname)))

                (symbol-macrolet ((grade-table (gethash std-name  *grade-table*))
                                  (lname-lut   (gethash lastname  *lname-lut*))
                                  (fname-lut   (gethash firstname *fname-lut*)))
                  (unless grade-table (setf grade-table student))
                  (macrolet ((set-table-entry (sym)
                               (let ((entry (mk-symbol "~a-lut" sym)))
                                 `(if (not ,entry)
                                      (setf ,entry (make-lookup-entry
                                                    :groups   (list 0)
                                                    :students (list std-name)))
                                      (unless (position std-name (lookup-entry-students ,entry))
                                        (push std-name (lookup-entry-students ,entry))
                                        (push 0 (lookup-entry-groups ,entry)))))))
                    (set-table-entry lname)
                    (set-table-entry fname))
                  (push std-name (getf (gethash 0 *group-table*) :members))))))))))

(defun set-grade (grade-list &key (firstname nil) (lastname nil))
  (macrolet ((set-grade (name)
               `(let* ((std-name ,name))
                  (symbol-macrolet ((grade (student-grade (gethash std-name *grade-table*))))
                    (if (gethash std-name *grade-table*)
                        (loop for lab in grade-list
                           do (funcall (fdefinition (list 'setf (mk-symbol "lab-grade-~a" (first lab))))
                                       (float (second lab)) grade))
                        (format t "Cannot find student : ~a~%" (display-name std-name))))))
             (set-grade-name (name table)
               `(let* ((std-name ,name)
                       (match (if (gethash std-name ,table)
                                  (lookup-entry-students (gethash std-name ,table))
                                  nil)))
                  (if match
                      (if (= (length match) 1)
                          (set-grade (first match))
                          (set-grade (select match
                                             #'(lambda (ith name)
                                                 (format *query-io* "~d : ~a~%"
                                                         ith (display-name name))))))
                      (format t "Cannot find student : ~a~%" std-name)))))
    (cond ((and firstname lastname)
           (set-grade (list :firstname firstname :lastname lastname)))
          (firstname (set-grade-name (string-downcase firstname) *fname-lut*))
          (lastname  (set-grade-name (string-downcase lastname)  *lname-lut*))
          (t (format t "No name is given.~%")))))

(defun mk-group (name-list)
  (let ((group-members nil))
    (loop for name in name-list
       do
         (let* ((token-list (cl-ppcre:split "\\s*,\\s*" name))
                (std-name (list :firstname (string-downcase (pop token-list))
                                :lastname  (string-downcase (pop token-list)))))
           ;; (format t "~a ~a~%" (getf fullname :firstname) (getf fullname :lastname))
           (symbol-macrolet ((group-id (if (gethash std-name *grade-table*)
                                           (student-gid (gethash std-name *grade-table*))
                                           nil)))
             (if (and group-id (not (equal group-id 0)))
                 (progn
                   (format t "** ~a is already in group ~d: **~%" name group-id)
                   (list-group-members group-id)
                   (format t "~%")
                   (return nil))
                 (if (gethash std-name *grade-table*)
                     (push std-name group-members)
                     (progn
                       (format t "** ~a is not found in roster. **~%" name)
                       (return nil))))))
         
       finally (when group-members
                 (let* ((id-generator (generator (hash-table-count *group-table*)))
                        (id (funcall id-generator)))
                   (loop while (gethash id *group-table*) do
                        (setq id (funcall id-generator)))
                   ;; (setf (getf (gethash id *group-table*) :members) group-members)
                   (loop for name in group-members do
                        (add-to-group id name)))))))

(defun add-to-group (group-id name &key (parse nil))
  (let ((std-name (if parse (proc-name name) name)))
    (symbol-macrolet ((record  (gethash std-name *grade-table*))
                      (group-members (getf (gethash group-id *group-table*) :members)))
      (if (not record)
          (format t "** Failed. Cannot find record for ~a. **~%" (display-name std-name))
          (if (/= (student-gid record) 0)
              (if (/= group-id (student-gid record))
                  (format t "** Failed. ~a is already in group ~d. **~%" (display-name std-name) group-id)
                  (format t "** ~a is already in this group. **~%" (display-name std-name)))
              (macrolet ((set-gid-entry (tag table)
                           `(setf (elt (lookup-entry-groups (gethash (getf std-name ,tag) ,table))
                                       (position std-name
                                                 (lookup-entry-students
                                                  (gethash (getf std-name ,tag) ,table))
                                                 :test #'equal))
                                  group-id)))
                (setf (student-gid record) group-id)
                (set-gid-entry :firstname *fname-lut*)
                (set-gid-entry :lastname *lname-lut*)
                (push std-name group-members)))))))

(defun remove-from-group (group-id name &key (parse nil))
  (let ((std-name (if parse (proc-name name) name)))
    
    (symbol-macrolet ((record             (gethash std-name *grade-table*) )
                      (member-list        (getf (gethash group-id *group-table*) :members)))
      (if (/= (student-gid record) group-id)
          (format t "** ~a does not belongs to this group. **~%" (display-name std-name))
          (macrolet  ((set-gid-entry (tag table)
                        `(setf (elt (lookup-entry-groups (gethash (getf std-name ,tag) ,table))
                                    (position std-name
                                              (lookup-entry-students
                                               (gethash (getf std-name ,tag) ,table))
                                              :test #'equal))
                               0)))
            (setf (student-gid record) 0)
            (set-gid-entry :firstname *fname-lut*)
            (set-gid-entry :lastname *lname-lut*)
            (setf member-list (delete std-name member-list :test #'equal)))))))

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



(defun change-group (group-id name &key (parse nil))
  (let* ((std-name (if parse (proc-name name) name))
         (curr-id (if (gethash std-name *grade-table*)
                      (student-gid (gethash std-name *grade-table*))
                      nil)))
    (if (equal curr-id group-id)
          (format t "** ~a is already in this group. **~%" (display-name std-name))
          (if curr-id
              (progn
                (remove-from-group curr-id std-name)
                (add-to-group group-id std-name))
              (format t "** ~a is not in roster. **~%" (display-name std-name)))))))

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

(defun set-group-grade (name-list grade-list)
  (let ((groups nil))
    (loop for name in name-list
       do
         (let* ((name (string-downcase name))
                (found nil))
           (macrolet ((push-if-found (name table)
                        `(when (gethash ,name ,table)
                           (push (lookup-entry-groups (gethash ,name ,table)) groups)
                           (setq found t))))
             (push-if-found name *fname-lut*)
             (push-if-found name *lname-lut*))
           (unless found
               (format t "** ~a is not found in roster. **~%" (string-upcase name :start 0 :end 1))
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
                       (loop for student in (getf (gethash group-id *group-table*) :members)
                          initially
                            (format t "Changing grade: ~%")
                          do
                            (progn
                              (set-grade grade-list
                                         :firstname (getf student :firstname)
                                         :lastname  (getf student :lastname))
                              (format t "   * ~a ~%" (display-name student))))))))))

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


(defun list-grades (labs)
  (let ((keys nil))
    (loop for key being the hash-keys of *grade-table* do
         (progn
           ;;(format t "~a~%" (display-name key))
           (push key keys)))
    (setq keys (quicksort-fn keys
                             :by  #'(lambda (name)
                                      (getf name :firstname))
                             :compare> #'string>
                             :compare< #'string<
                             :compare= #'string=))
    (loop for key being the elements of keys do
         (progn
           (format t "~10a ~16a |" (getf key :firstname) (getf key :lastname))
           (loop for lab in labs do
                (format t " ~4,1f" (funcall (mk-symbol "lab-grade-~a" lab)
                                 (student-grade (gethash key *grade-table*)))))
           (format t "~%")))))

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

(defmacro set-table-entry (sym)
  (let ((lut            (mk-symbol "~a-lut" sym))
        (make-entry     (mk-symbol "make-~a-entry" sym))
        (entry-students (mk-symbol "~a-entry-students" sym))
        (entry-groups   (mk-symbol "~a-entry-groups" sym)))
    `(if (not ,lut)
         (setf ,lut (,make-entry :groups (list 0)
                                 :students (list (student-name student))))
         (unless (position (student-name student) (,entry-students ,lut))
           (push (student-name student) (,entry-students ,lut))
           (push 0 (,entry-groups ,lut))))))

(defun import-grade (file))
