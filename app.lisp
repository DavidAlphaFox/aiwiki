(ql:quickload :aiwiki)

(defpackage aiwiki.app
  (:use :cl)
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
  (:import-from
   :aiwiki.base.config
   :config
   :productionp
   :*static-directory*))
(in-package :aiwiki.app)

(defun static-path (path)
  (if (ppcre:scan "^(?:/images/|/css/|/js/|/robot\\.txt$|/favicon\\.ico$)" path)
      path
      nil))

(defun wrap-trace-sql (app)
  (lambda (env)
         (let ((datafly:*trace-sql* t)) ;; 如果非生产环境提供sql的追踪
           (funcall app env))))

(builder
 (:static
  :path #'static-path
  :root *static-directory*)
 (if (productionp) nil :accesslog)
;; (if (getf (config) :error-log) `(:backtrace :output ,(getf (config) :error-log)) nil)
 :session (if (productionp) nil #'wrap-trace-sql)
 *web*)
