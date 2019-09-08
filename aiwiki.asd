(in-package :cl-user)
(defpackage aiwiki-asd
  (:use :cl :asdf))
(in-package :aiwiki-asd)

(defsystem aiwiki
  :version "0.1"
  :author "David.Gao"
  :license "MIT"
  :depends-on (:clack
               :lack
               :caveman2
               :envy
               :cl-ppcre
               :quri
               :uiop
               :woo
               ;; for @route annotation
               :cl-syntax-annot
               ;; HTML Template
               :djula
               ;; for DB
               :datafly
               :sxql
               ;; Password hashing
               :cl-pass
               ;; Markdown
               :3bmd
               :3bmd-ext-wiki-links
               :3bmd-ext-code-blocks
               )
  :components ((:module "src"
                :serial t
                :components
                ((:module "base"
                  :components
                  ((:file "config")
                   (:file "view" :depends-on ("config"))
                   (:file "db" :depends-on ("config"))
                   ))
                 (:module "model"
                  :depends-on ("base")
                  :components
                  ((:file "page")
                   (:file "link")
                   (:file "tag")
                   (:file "site")))
                 (:module "utils"
                  :depends-on ("base")
                  :components
                  ((:file "request")
                   (:file "markdown")
                   (:file "pagination")
                   (:file "view")))
                 (:module "view"
                  :depends-on ("base" "model" "utils")
                  :components
                  ((:file "index")
                   (:file "page")
                   (:file "package" :depends-on ("index" "page"))
                   ))
                 (:file "main" :depends-on ("base" "model" "utils" "view"))
                 )))
  :description ""
  :in-order-to ((test-op (load-op aiwiki-test))))
