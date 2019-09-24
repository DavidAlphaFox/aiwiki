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

(defun logged-in-p ()
  "Check if a user is currently logged in, return the username"
  (gethash :username *session*))

(defmacro must-be-logged-out (&body body)
  "If user is logged in, return a rendered HTML page with an error message, else elavuate body"
  `(if (logged-in-p)
       (render #P "error.html" (list :username (logged-in-p)
                                     :messages '("You are already logged in. Please log out first")))
       (progn ,@body)))

(defmacro must-be-logged-in (&body body)
  "If user isn't logged in, return a rendered HTML page with an error message, else evaluate body"
  `(if (logged-in-p)
       (progn ,@body)
       (render #P "error.html" (list :username (logged-in-p)
                                     :messages '("You must be logged in to do that")))))
