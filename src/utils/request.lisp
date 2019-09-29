(in-package :cl-user)
(defpackage aiwiki.utils.request
  (:use
   :cl
   :caveman2)
  (:export
   :fetch-parameter
   :fetch-parameter-with-default
   :fetch-json-body))

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

(defun fetch-json-body ()
  (let* ((body-length (request-content-length *request*))
         (buf (make-array body-length  :adjustable t :fill-pointer body-length)))
    (read-sequence buf (request-raw-body *request*))
    (cl-json:decode-json-from-string (flex:octets-to-string buf :external-format :utf8))))

