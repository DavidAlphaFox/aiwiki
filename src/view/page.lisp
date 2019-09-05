(in-package :cl-user)
(defpackage aiwiki.view.page
  (:use
   :cl
   :caveman2
   :aiwiki.base.view
   :aiwiki.view.utils
   :aiwiki.model.page)
  (:export
   :action-show))

(in-package :aiwiki.view.page)

;;
;; Routing rules

(defun action-show (id title)
  (let ((page (page-by-id id)))
    (render #P"page/show.html" (parse-markdown-page page))))
