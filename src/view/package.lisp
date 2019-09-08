(in-package :cl-user)

(defpackage aiwiki.view
  (:use
   :cl
   :caveman2)
  (:import-from
   :caveman2
   :<app>
   :throw-code)
  (:export
   :*web*))

(in-package aiwiki.view)
;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)
;;(syntax:use-syntax :annot)

(defmacro with-exception-handler (&body body)
  `(handler-case ,@body
     (t (c) (throw-code 500))))


(defroute ("/" :method :GET) () (with-exception-handler (aiwiki.view.index:action-index)))
(defroute ("/page/:id/:title" :method :GET) (&key id title) (aiwiki.view.page:action-show id title))
;;
;; Error pages
(defmethod on-exception ((app <web>) (code (eql 500)))
  (declare (ignore app code))
  (merge-pathnames #P"errors/404.html"
                   aiwiki.base.config:*template-directory*))

;;(defmethod on-exception ((app <web>) (code (eql 404)))
;;  (declare (ignore app code))
;;  (merge-pathnames #P"errors/404.html"
;;                   *template-directory*))
