;; Methods for importing/loading records

(in-package :grading)

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


