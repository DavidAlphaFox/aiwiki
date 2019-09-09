(in-package :cl-user)
(defpackage aiwiki.view.page
  (:use
   :cl
   :caveman2
   :aiwiki.utils.view
   :aiwiki.utils.markdown
   :aiwiki.model.page)
  (:export
   :show-html
   :show-json))

(in-package :aiwiki.view.page)

;;
;; Routing rules

(defun show-html (id title)
  (let ((page (page-by-id id)))
    (render-view #P"page/show.html" (parse-page page))))

(defun show-json (id title)
  (let ((page (page-by-id id)))
    (render-json page)))
