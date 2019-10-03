(in-package :cl-user)
(defpackage aiwiki.utils.auth
  (:use
   :cl
   :caveman2)
  (:import-from
   :aiwiki.base.config
   :config)
  (:import-from
   :aiwiki.base.time
   :timestamp)
  (:export
   :gen-token
   :authenticated-user
   :authenticate-user
   :must-be-looged-in
   :verified-token
   ))

(in-package :aiwiki.utils.auth)


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

(defun authenticated ()
  (handler-case
      (let ((bearer (gethash "authorization" (request-headers *request*))))
        (if bearer
          (get-claim (cadr (split-sequence:split-sequence #\space bearer)))
          nil))
    (t (c) nil)))

(defun verified-token ()
  (let* ((claim (authenticated))
         (now (timestamp))
         (expired (cdr (assoc "expired" claim :test #'string=)))
         (username (cdr (assoc "username" claim :test #'string=)))
         (diff (- now expired)))
    (cond ((> diff 0) (list nil nil))
          ((> diff -7200) (list nil username))
          (t (list t username)))))
(defun authenticated-user ()
  (let ((claim (authenticated)))
    (cdr (assoc "username" claim :test #'string=))))

(defmacro must-be-logged-in (&body body)
  `(if (authenticated)
       (progn ,@body)
       (setf (response-status *response*) "403")))

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
