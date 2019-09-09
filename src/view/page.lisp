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
   :index-json
   :show-html
   :show-json))

(in-package :aiwiki.view.page)

;;
;; Routing rules

(defun index-json ()
  (let* ((page-index (parse-integer (fetch-parameter-with-default "pageIndex" "1")))
         (page-size  (parse-integer (fetch-parameter-with-default "pageSize" "10")))
         (pages (pages-only-title page-index page-size))
         (total (total-pages)))
    (render-json (list* :pages pages total) )))

(defun show-html (id title)
  (let ((page (page-by-id id)))
    (render-view #P"page/show.html" (parse-page page))))

(defun show-json (id title)
  (let ((page (page-by-id id)))
    (render-json page)))
