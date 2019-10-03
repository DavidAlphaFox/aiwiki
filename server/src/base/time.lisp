(in-package :cl-user)
(defpackage aiwiki.base.time
  (:use :cl)
  (:export
   :timestamp))
(in-package :aiwiki.base.time)

(defun timestamp () (local-time:timestamp-to-unix (local-time:now)))
