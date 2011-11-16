(ql:quickload :cl-ppcre)

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

  ;; (import-name-list "~/Downloads/CSE310-01F11_Grades.txt")
  ;; (mapc #'mk-group
  ;;       '(("Jeremiah, Lukacs" "Albert,Banuelos") ;; :lab4 10; :lab5 10; :lab8, bcd finished in lab
  ;;         ("Cory, Cook" "Roman,Ruiz" "Corey,Lunt") ;; :lab4 7, no source & diagram; :lab5 8, missing timing
  ;;         ("Douglas,Duncan" "Jessica,Brown") ;; :lab4 10; :lab5 10; 
  ;;         ("Edward,Munoz III" "Guillermo,Garcia Jr") ;; 
  ;;         ("Bryan,Johnson" "Taylor,Sanchez" "Diego,Bernal") ;;
  ;;         ("Johnny,Nguyen" "David,Smit" "Jonathan,Carranza") ;; 
  ;;         ("Manuel,Del Rio" "Christina,Torres") ;; 
  ;;         ("Andrew,Davis" "Eugene,Chandler") ;; 
  ;;         ("Maurice,Njuguna" "Mac,Chou") ;; lab5 , no source & diagram; 
  ;;         ("Paul,Cummings" "Gustavo,Cruz") ;; lab5, incomplete source
  ;;         ("La,Van Doren Jr" "Darin,Truckenmiller") ;;
  ;;         ("Ran,Wei" "Muhammad,Ali") ;; 

  ;;         ("Viviane,Helmig" "Roman,Savilov" "Abigail,Farrier") ;; 
  ;;         ("Anthony,Phillips" "Theodore,Phillips II" "Aminul,Hasan") ;; 
  ;;         ("Evan,Casey" "Ngan,Do" "Kyle,Johnson");; 
  ;;         ("Michael,Shabsin" "Nikolay,Figurin") ;; 
  ;;         ("Lavern,Slusher Jr" "Michael,Korcha I" "Garrett,Albers") ;; 
  ;;         ("Jeffrey,Carter" "Henry,Gomez" "Dennis,Zamora") ;; 
  ;;         ("Bryan,Amann" "Sean,Finucane" "Peter,Diaz III") ;; 
  ;;         ("Ahmed,Kamel" "Dylan,Allbee" "Ryan,Stegmann") ;; 
  ;;         ("Kanika,Bhat" "Francisco,Ron" "Janette,Rodriguez") ;;  :lab 8, working
  ;;         ("Carlos,Gomez Viramontes" "Ryan,Rady") ;; 
  ;;         ("Henry,Johnson" "Dillon,Li" "Michael,Schenk") ;; 
  ;;         ("Joey,Cantellano" "Abraham,Flores Jr"))) ;; 
  
  ;; (set-group-grade '((:lab1 6) (:lab4 10) (:lab5 10))
  ;;                  '("jeremiah" "albert"))
  ;; (set-group-grade '((:lab1 6) (:lab4 7) (:lab5 8))
  ;;                  '("cory" "roman"))
  ;; (set-group-grade '((:lab4 10) (:lab5 10))
  ;;                  '("duncan" "jessica"))
  ;; (set-group-grade '((:lab1 6) (:lab4 10) (:lab5 10))
  ;;                  '("edward" "guillermo"))
  ;; (set-group-grade '((:lab1 6) (:lab4 10) (:lab5 10) )
  ;;                  '("bryan" "taylor"))
  ;; (set-group-grade '((:lab4 10) (:lab5 10))
  ;;                  '("johnny" "david"))
  ;; (set-group-grade '((:lab4 8) (:lab5 10))
  ;;                  '("manuel" "torres"))
  ;; (set-group-grade '((:lab4 10) (:lab5 10))
  ;;                  '("andrew" "eugene"))
  ;; (set-group-grade '((:lab1 6) (:lab4 8) (:lab5 5))
  ;;                  '("maurice" "chou"))
  ;; (set-group-grade '((:lab4 10) (:lab5 9))
  ;;                  '("paul" "Gustavo"))
  ;; (set-group-grade '((:lab4 8) (:lab5 10))
  ;;                  '("la" "darin"))
  ;; (set-group-grade '((:lab1 5) (:lab4 10) (:lab5 10) )
  ;;                  '("ran" "ali"))

  ;; (set-group-grade '((:lab5 8) (:lab6 10))
  ;;                  '("viviane" "roman"))
  ;; (set-group-grade '((:lab5 8)  (:lab5 8))
  ;;                  '("phillips" "hasan"))
  ;; (set-group-grade '((:lab6 7)  (:lab5 9))
  ;;                  '("evan" "ngan"))
  ;; (set-group-grade '((:lab4 6) (:lab5 5) (:lab6 6))
  ;;                  '("michael" "nikolay"))
  ;; (set-group-grade '((:lab5 8) (:lab6 8))
  ;;                  '("lavern" "michael"))
  ;; (set-group-grade '((:lab5 6) (:lab6 7))
  ;;                  '("jeffrey" "henry"))
  ;; (set-group-grade '((:lab5 10) (:lab6 10))
  ;;                  '("bryan" "sean"))
  ;; (set-group-grade '((:lab4 8) (:lab5 10) (:lab6 10))
  ;;                  '("ahmed" "dylan"))
  ;; (set-group-grade '((:lab5 8) (:lab6 8))
  ;;                  '("kanika" "ron"))
  ;; (set-group-grade '((:lab5  10) (:lab6 10))
  ;;                  '("carlos" "ryan"))
  ;; (set-group-grade '((:lab5 10) (:lab6 10))
  ;;                  '("henry" "dillon"))
  ;; (set-group-grade '((:lab5 8) (:lab6 10))
  ;;                  '("joey" "abraham"))
  (if dump (print-grade-table)))

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

(defun load-grade-csv (filename)
  (setq *grade-table* (make-hash-table :test #'equal))
  (setq *fname-lut*   (make-hash-table :test #'equal))
  (setq *lname-lut*   (make-hash-table :test #'equal))
  (setq *group-table* (make-hash-table :test #'equal))
  (with-open-file (in filename
                      :direction :input)
    (read-line in nil) ;; skip first line
    (do ((line (read-line in nil)
               (read-line in nil)))
        ((null line))
      (let* ((tokens (cl-ppcre:split "\\s*,\\s*" line))
             (fullname (list :firstname (pop tokens)
                             :lastname (pop tokens)))
             (group-id (parse-integer (pop tokens) :junk-allowed t))
             (email (pop tokens)))
        (setf (gethash fullname *grade-table*)
              (list :group-id group-id
                    :email email
                    :lab-grade (list :lab1  (parse-integer (pop tokens) :junk-allowed t)
                                     :lab2  (parse-integer (pop tokens) :junk-allowed t)
                                     :lab3  (parse-integer (pop tokens) :junk-allowed t)
                                     :lab4  (parse-integer (pop tokens) :junk-allowed t)
                                     :lab5  (parse-integer (pop tokens) :junk-allowed t)
                                     :lab6  (parse-integer (pop tokens) :junk-allowed t)
                                     :lab7  (parse-integer (pop tokens) :junk-allowed t)
                                     :lab8  (parse-integer (pop tokens) :junk-allowed t)
                                     :lab9  (parse-integer (pop tokens) :junk-allowed t)
                                     :lab10 (parse-integer (pop tokens) :junk-allowed t))))
        (push fullname (getf (gethash group-id *group-table*) :members))
        (macrolet ((set-entry (nametag table)
                     `(progn
                        (push group-id (getf (gethash (getf fullname ,nametag) ,table) :group-id))
                        (push fullname (getf (gethash (getf fullname ,nametag) ,table) :fullname)))))
          (set-entry :firstname *fname-lut*)
          (set-entry :lastname *lname-lut*))))))

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

(defun print-grade-table ()
  (print-title)
  (maphash #'print-grade-student
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

;; (defmacro check-grade (names)
;;   )

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
                                  (lname-entry  (gethash lastname  *lname-lut*))
                                  (fname-entry  (gethash firstname *fname-lut*)))
                  (setf (getf table-entry :group-id) nil)
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
                  (unless (position fullname lname-entry :test #'equal)
                    (push fullname (getf lname-entry :fullname))
                    (push nil (getf lname-entry :group-id)))
                  (unless (position fullname fname-entry :test #'equal)
                    (push fullname (getf fname-entry :fullname))
                    (push nil (getf fname-entry :group-id)))
                  ;; (format t "~a, ~a : ~a~%" firstname lastname email)
                  ))))))))

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

(defun set-group-grade (grade-list name-list)
  (let ((group-id (choose-group name-list)))
    (if (null group-id)
        (format t "** Could not locate a group that has these students. **")
        (loop for student in (getf (gethash group-id *group-table*) :members) do
             (set-grade grade-list
                        :firstname (getf student :firstname)
                        :lastname  (getf student :lastname))))))


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
