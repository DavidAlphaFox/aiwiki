(in-package :cl-user)
(defpackage aiwiki.view.page
  (:use
   :cl
   :caveman2
   :aiwiki.utils.view
   :aiwiki.utils.markdown
   :aiwiki.utils.request
   :aiwiki.model.page)
  (:export
   :create-json
   :show))

(in-package :aiwiki.view.page)

;;
;; Routing rules

(defun create-json ()
  (let* ((body (fetch-json-body))
         (title (assoc "title" body))
         (intro (assoc "intro" body))
         (content (assoc "content" body)))
    (render-json body)))

(defun show (id title)
  (let ((page (page-by-id id)))
    (render-view #P"page/show.html" (parse-page page))))

