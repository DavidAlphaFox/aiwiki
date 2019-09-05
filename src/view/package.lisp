(in-package :cl-user)

(defpackage aiwiki.view
  (:use
   :cl
   :caveman2
   :aiwiki.view.index)
  (:export
   :*web*))

(in-package aiwiki.view)
;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)
(syntax:use-syntax :annot)

(defroute "/" () (action-index))
;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))

