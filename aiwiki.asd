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
                          ((:file "user")
                           (:file "page")
                           (:file "tag")
                           (:file "package" :depends-on ("user" "page" "tag"))
                           ))
                         (:module "web"
                          :depends-on ("base" "model")
                          :components
                          ((:file "utils")
                           (:file "user")
                           (:file "page")
                           (:file "package" :depends-on ("user" "page"))
                           ))
                         (:file "main" :depends-on ("base" "model" "web"))
                        )))
  :description ""
  :in-order-to ((test-op (load-op aiwiki-test))))
