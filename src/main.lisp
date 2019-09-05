(in-package :cl-user)

(defpackage aiwiki
  (:use :cl)
  (:import-from
   :aiwiki.base.config
   :config)
  (:import-from
   :clack
   :clackup)
  (:export :start
           :stop))
(in-package :aiwiki)

(defvar *appfile-path*
  (asdf:system-relative-pathname :aiwiki #P"app.lisp"))

(defvar *handler* nil)

(defun start (&rest args &key server port debug &allow-other-keys)
  (declare (ignore server port debug))
  (when *handler*
    (restart-case (error "Server is already running.")
      (restart-server ()
        :report "Restart the server"
        (stop))))
  (setf *handler* (clackup *appfile-path*)))

(defun stop ()
  (prog1
      (clack:stop *handler*)
    (setf *handler* nil)))
