(ql:quickload :aiwiki)

(defpackage aiwiki.app
  (:use :cl)
  (:import-from :lack.builder
                :builder)
  (:import-from :ppcre
                :scan
                :regex-replace)
  (:import-from :aiwiki.web
                :*web*)
  (:import-from :aiwiki.config
                :config
                :productionp
                :*static-directory*))
(in-package :aiwiki.app)

(builder
 (:static
  :path (lambda (path)
          ;; images,css,js,robot.txt,favicon.ico 就使用当前路径
          (if (ppcre:scan "^(?:/images/|/css/|/js/|/robot\\.txt$|/favicon\\.ico$)" path)
              path
              nil))
  :root *static-directory*)
 (if (productionp)
     nil
     :accesslog)
 (if (getf (config) :error-log)
     `(:backtrace
       :output ,(getf (config) :error-log))
     nil)
 :session
 (if (productionp)
     nil
     (lambda (app)
       (lambda (env)
         (let ((datafly:*trace-sql* t)) ;; 如果非生产环境提供sql的追踪
           (funcall app env)))))
 *web*)
