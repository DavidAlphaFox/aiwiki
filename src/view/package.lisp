(in-package :cl-user)

(defpackage aiwiki.view
  (:use
   :cl
   :caveman2)
  (:export
   :*web*))

(in-package aiwiki.view)
;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)
(syntax:use-syntax :annot)

(defroute "/" () (aiwiki.view.index:action-index))
(defroute "/page/:id/:title" (&key id title) (aiwiki.view.page:action-show id title))
;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
