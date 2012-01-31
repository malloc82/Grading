;; table definition
(in-package :grading)

(defvar *grade-table* (make-hash-table :test #'equal))
(defvar *fname-lut* (make-hash-table :test #'equal))
(defvar *lname-lut* (make-hash-table :test #'equal))
(defvar *group-table* (make-hash-table :test #'equal))
