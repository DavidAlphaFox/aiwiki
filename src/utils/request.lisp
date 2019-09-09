(in-package :cl-user)
(defpackage aiwiki.utils.request
  (:use
   :cl
   :caveman2)
  (:export
   :fetch-parameter
   :fetch-parameter-with-default))

(in-package :aiwiki.utils.request)

;;
;; Utils

(defun fetch-parameter-with-default (parameter defaultValue)
  (let ((matched (assoc parameter (request-parameters *request*) :test #'string=)))
    (cond ((equal matched nil) defaultValue)
          (t (cdr matched)))))

(defun fetch-parameter (parameter)
  "Get a parameter from the request body"
  (cdr (assoc parameter (request-parameters *request*) :test #'string=)))
