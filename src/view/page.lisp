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
   :create-json
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

(defun create-json ()
  (let* ((body (fetch-json-body))
         (title (assoc "title" body))
         (intro (assoc "intro" body))
         (content (assoc "content" body)))
    (render-json body)))

(defun show-html (id title)
  (let ((page (page-by-id id)))
    (render-view #P"page/show.html" (parse-page page))))

(defun show-json (id title)
  (let ((page (page-by-id id)))
    (render-json page)))
