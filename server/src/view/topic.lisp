(in-package :cl-user)
(defpackage aiwiki.view.topic
  (:use
   :cl
   :caveman2
   :aiwiki.utils.view
   :aiwiki.utils.markdown
   :aiwiki.utils.request
   :aiwiki.model.page
   :aiwiki.model.topic)
  (:export
   :show))

(in-package :aiwiki.view.topic)

(defun show (id title)
  (let* ((topic (topic-by-id id))
         (page-index (parse-integer (fetch-parameter-with-default "pageIndex" "1")))
         (page-size  (parse-integer (fetch-parameter-with-default "pageSize" "10")))
         (total (getf (total-pages :published t :topic-id id) :total)))
