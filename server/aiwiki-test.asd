(in-package :cl-user)
(defpackage aiwiki-test-asd
  (:use :cl :asdf))
(in-package :aiwiki-test-asd)

(defsystem aiwiki-test
  :author "David.Gao"
  :license "MIT"
  :depends-on (:aiwiki
               :prove)
  :components ((:module "t"
                :components
                ((:file "aiwiki"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
