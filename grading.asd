;;; -*- mode: lisp -*-

(asdf:defsystem :grading
  :author    ("Ritchie Cai")
  :maintainer "Ritchie Cai"
  ;; :licencse ???
  :description "A small grading utilty as an alternative to excel."
  :long-description "Grading facility meant to be make class grade maintainance to be less tedious. This is an attempt to create a more expressive and more versitile tool than traditional excel table which I personally find it very tideous to use. So far it is only meant to be executed inside slime-repl."
  :depends-on (:cl-ppcre)
  :components
  ((:file "pkgdcl" )
   (:file "tables"  :depends-on ("pkgdcl"))
   (:file "utils"   :depends-on ("pkgdcl" "tables"))   
   (:file "load"    :depends-on ("pkgdcl" "tables" "utils"))
   (:file "output"  :depends-on ("pkgdcl" "tables" "utils"))
   (:file "grading" :depends-on ("pkgdcl" "tables" "utils"))   
   )
  )