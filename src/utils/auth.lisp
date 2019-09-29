(in-package :cl-user)
(defpackage aiwiki.utils.auth
  (:use
   :cl
   :caveman2)
  (:import-from
   :aiwiki.base.config
   :config)
  (:export
   :must-be-logged-out
   :must-be-looged-in
   :authenticate-user
   :gen-token
   :get-claim
   :login
   :logout
   ))

(in-package :aiwiki.utils.auth)


(defun timestamp () (local-time:timestamp-to-unix (local-time:now)))

(defun jose-secret ()
  (ironclad:ascii-string-to-byte-array (config :secret)))

(defun jose-expired ()
  (let ((now (timestamp)))
    (+ now 28800)))

(defun gen-token (username)
  (let* ((expired (jose-expired))
         (claim `(("username" . ,username)
                  ("expired" . ,expired)))
         (secret (jose-secret))
         (token (jose:encode :hs256 secret claim)))
    token ))

(defun get-claim (token)
  (let* ((secret (jose-secret))
         (now (timestamp))
         (claim (jose:decode :hs256 secret token))
         (expired (cdr (assoc "expired" claim :test #'string=)))
         (diff (- now expired)))
    (if (< diff 0) claim nil)))

(defun logged-in-p ()
  (gethash :token *session*))

(defun login (username)
  (let ((token (gen-token username)))
    (setf (gethash :token *session*) token)))

(defun logout ()
  (setf (gethash :token *session*) nil))

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

(defun authenticate-user (user password)
  "Lookup user record and validate password. Returns two values:
   1st value, was password correct T or NIL
   2nd value, was user found, T or NIL
Example:
   (VALUES NIL NIL) -> user not found
   (VALUES NIL T) -> user found, but wrong password
   (VALUES T T) -> password correct"
  (let ((password-hash (getf user :password)))
    (if password-hash
        (values (cl-pass:check-password password password-hash) t)
        (values nil nil))))
