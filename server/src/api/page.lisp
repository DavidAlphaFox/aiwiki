(in-package :cl-user)
(defpackage aiwiki.api.page
  (:use
   :cl
   :caveman2
   :aiwiki.utils.view
   :aiwiki.utils.request
   :aiwiki.model.page)
  (:export
   :index
   :show
   :update
   ))

(in-package :aiwiki.api.page)

;;
;; Routing rules
(defun index ()
  (let* ((page-index (parse-integer (fetch-parameter-with-default "pageIndex" "1")))
         (page-size  (parse-integer (fetch-parameter-with-default "pageSize" "10")))
         (pages (pages-only-title page-index page-size))
         (total (total-pages)))
    (render-json (list* :pages pages total) )))

(defun show (id)
  (let ((page (page-by-id id)))
    (render-json page)))

(defun create ()
  (let* ((body (fetch-json-body))
         (title (assoc "title" body))
         (intro (assoc "intro" body))
         (content (assoc "content" body)))
    (render-json body)))


(defun update (id)
  (let ((title (fetch-parameter "title"))
        (intro (fetch-parameter "intro"))
        (content (fetch-parameter "content"))
        (published (fetch-parameter "published")))
    (update-page id title intro content published)
    (show id)
  ))
