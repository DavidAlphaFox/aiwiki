(in-package :cl-user)
(defpackage aiwiki.utils.view
  (:use :cl)
  (:import-from
   :aiwiki.base.view
   :render
   :render-json)
  (:import-from
   :aiwiki.model.site
   :fetch-site)
  (:export
   :gen-page-title
   :gen-page-url
   :render-view
   :render-json))

(in-package :aiwiki.utils.view)

(defmacro gen-page-title (topic-title page-title)
  `(format nil "[~a]~a" ,topic-title ,page-title))
(defmacro gen-page-url (page-id page-title)
  `(format nil "/pages/~d/~a.html"
           ,page-id
           (quri:url-encode ,page-title)))

(defun render-view (template-path &optional env)
  (let ((site (fetch-site)))
    (render template-path (list* :site site env))))
