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
   :*static-directory*)
  (:import-from
   :caveman2
   :throw-code))
(in-package :aiwiki.app)


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
 *web*)
