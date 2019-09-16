(in-package :cl-user)
(defpackage aiwiki.view.page-admin
  (:use
   :cl
   :caveman2
   :aiwiki.utils.view
   :aiwiki.utils.request
   :aiwiki.model.page)
  (:export
   :show-html))

(in-package :aiwiki.view.page-admin)

;;
;; Routing rules
(defun show-html (id title)
  (let ((page (page-by-id id)))
    (render-view #P"admin/page/show.html" page)))
