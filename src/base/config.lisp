(in-package :cl-user)
(defpackage aiwiki.base.config
  (:use :cl)
  (:import-from
   :envy
   :config-env-var
   :defconfig)
  (:export
   :config
   :*application-root*
   :*static-directory*
   :*template-directory*
   :appenv
   :developmentp
   :productionp))

(in-package :aiwiki.base.config)


(setf (config-env-var) "APP_ENV")

(defparameter *application-root*   (asdf:system-source-directory :aiwiki))
(defparameter *static-directory*   (merge-pathnames #P"static/" *application-root*))
(defparameter *template-directory* (merge-pathnames #P"templates/" *application-root*))

(defconfig :common
    `(:databases ((:maindb :postgres
                   :database-name "ttalk"
                   :username "david"
                   :host "127.0.0.1"
                   ))))

(defconfig |development|
  '())

(defconfig |production|
  '())

(defconfig |test|
  '())

;; #. reader macro 可以让我们在
;; 编译阶段直接执行，而不是等到运行期间
;; 编译的时候直接将(package-name *package*)替换成 aiwiki.config
;; 如果放到运行时，就会根据所在的*package*进行动态的获取
(defun config (&optional key)
  (envy:config #.(package-name *package*) key))

(defun appenv ()
  (uiop:getenv (config-env-var #.(package-name *package*))))

(defun developmentp ()
  (string= (appenv) "development"))

(defun productionp ()
  (string= (appenv) "production"))
