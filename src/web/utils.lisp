(in-package :cl-user)
(defpackage aiwiki.web.utils
  (:use
   :cl
   :caveman2
   :datafly
   :sxql)
  (:export
   :get-request-parameter
   :login
   :logout
   :logged-in-p
   :must-be-logged-out
   :must-be-logged-in
   :parse-markdown-page))
(in-package :aiwiki.web.utils)



;;
;; Utils

(defun get-request-parameter (parameter)
  "Get a parameter from the request body"
  (cdr (assoc parameter (request-body-parameters *request*) :test #'string=)))

(defun login (username)
  "Log a user in"
  (setf (gethash :username *session*) username))

(defun logout ()
  "Log a user out"
  (setf (gethash :username *session*) nil))

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

;; wiki

(defmethod 3bmd-wiki:process-wiki-link ((wiki (eql :fsw)) normalized-target formatted-target args stream)
  (let (encode-target (quri:url-encode title))
    (if args
      (format stream "<a href=\"/page/~a/~{~a~}\">~a</a>" encode-target args formatted-target)
      (format stream "<a href=\"/page/~a\">~a</a>" encode-target formatted-target))
    ))

(defun parse-markdown-page (page)
  (let* ((3bmd-wiki:*wiki-links* t)
         (3bmd-wiki:*wiki-processor* :fsw)
         (content (with-output-to-string (out)
                    (3bmd:parse-string-and-print-to-stream (getf page :content) out))))
    (list* :content content page)))



