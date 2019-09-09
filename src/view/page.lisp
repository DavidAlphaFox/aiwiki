(in-package :cl-user)
(defpackage aiwiki.view.page
  (:use
   :cl
   :caveman2
   :aiwiki.utils.view
   :aiwiki.utils.markdown
   :aiwiki.model.page)
  (:export
   :action-show))

(in-package :aiwiki.view.page)

;;
;; Routing rules

(defun action-show (id title)
  (let ((page (page-by-id id)))
    (render-view #P"page/show.html" (parse-page page))))
