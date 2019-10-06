(in-package :cl-user)
(defpackage aiwiki.api.page
  (:use
   :cl
   :caveman2
   :aiwiki.utils.view
   :aiwiki.utils.request
   :aiwiki.model.page)
  (:import-from
   :dbi.error
   :<dbi-database-error>)
  (:export
   :index
   :create
   :show
   :update
   ))

(in-package :aiwiki.api.page)

;;
;; Routing rules
(defun index ()
  (let* ((page-index (parse-integer (fetch-parameter-with-default "pageIndex" "1")))
         (page-size  (parse-integer (fetch-parameter-with-default "pageSize" "10")))
         (pages (pages-with-published page-index page-size))
         (total (total-pages)))
    (render-json (list* :pages pages total) )))

(defun show (id)
  (let ((page (page-by-id id)))
    (render-json page)))

(defun create ()
  (handler-case
      (let* ((title (fetch-parameter "title"))
             (intro (fetch-parameter "intro"))
             (content (fetch-parameter "content"))
             (topic-id (fetch-parameter "topicId"))
             (result (add-page title intro content topic-id)))
        (render-json result))
    (<dbi-database-error> (c)
      ;; postgresql error code 23505
      (setf (response-status *response*) "409"))))

(defun update (id)
  (handler-case
      (let ((title (fetch-parameter "title"))
            (intro (fetch-parameter "intro"))
            (content (fetch-parameter "content"))
            (topic-id (fetch-parameter "topicId"))
            (published (fetch-parameter "published")))
        (update-page id title intro content published topic-id)
        (show id))
    (<dbi-database-error> (c)
      (setf (response-status *response*) "409"))))
