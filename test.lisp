(in-package :grading)

(defun test-reset (&key (dump nil))
  "This function is used for testing. It will reset all the tables, reload default data."
  (setq *grade-table* (make-hash-table :test #'equal))
  (setq *fname-lut*   (make-hash-table :test #'equal))
  (setq *lname-lut*   (make-hash-table :test #'equal))
  (setq *group-table* (make-hash-table :test #'equal))

  (import-name-list "~/Downloads/CSE310-01F11_Grades.txt")
  (if dump (print-grade-table)))
