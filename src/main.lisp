(in-package :cl-user)

(defpackage aiwiki
  (:use :cl)
  (:import-from
   :aiwiki.base.config
   :config
   :productionp
   :*static-directory*)
  (:import-from
   :clack
   :clackup)
  (:import-from
   :lack.builder
   :builder)
  (:import-from
   :ppcre
   :scan
   :regex-replace)
  (:import-from
   :aiwiki.view
   :*web*)
  (:export :start
           :stop))
(in-package :aiwiki)

;;(defvar *appfile-path*
;;  (asdf:system-relative-pathname :aiwiki #P"app.lisp"))

(defparameter *app*
  (builder
   (:static
    :path(lambda (path)
           (if (ppcre:scan "^(?:/images/|/css/|/js/|/robot\\.txt$|/favicon\\.ico$)" path)
             path
             nil))
    :root *static-directory*)
   (if (productionp) nil :accesslog)
   (if (getf (config) :error-log) `(:backtrace :output ,(getf (config) :error-log)) nil)
   :session (if (productionp) nil
              (lambda (app)
                (lambda (env)
                  (let ((datafly:*trace-sql* t)) ;; 如果非生产环境提供sql的追踪
                    (funcall app env)))))
   *web*))

(defvar *handler* nil)

(defun start (&rest args &key address server port debug &allow-other-keys)
  (declare (ignore address server port debug))
  (when *handler*
    (restart-case (error "Server is already running.")
      (restart-server ()
        :report "Restart the server"
        (stop))))
  (setf *handler* (apply #'clackup *app* args)))

(defun stop ()
  (prog1
      (if (not (equal *handler* nil)) (clack:stop *handler*))
    (setf *handler* nil)))
