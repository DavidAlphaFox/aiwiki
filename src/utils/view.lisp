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
   :render-view
   :render-json))

(in-package :aiwiki.utils.view)

(defun render-view (template-path &optional env)
  (let ((site (fetch-site)))
    (render template-path (list* :site site env))))
