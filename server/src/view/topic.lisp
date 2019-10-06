(in-package :cl-user)
(defpackage aiwiki.view.topic
  (:use
   :cl
   :caveman2
   :aiwiki.utils.view
   :aiwiki.utils.markdown
   :aiwiki.utils.pagination
   :aiwiki.utils.request
   :aiwiki.model.page
   :aiwiki.model.topic)
  (:export
   :show))

(in-package :aiwiki.view.topic)
(defun load-pages (page-index page-size topic)
  (let ((pages (pages-with-intro page-index page-size
                                 :topic-id (getf topic :id))))
    (loop for page in pages
          collect (list
                   :title (gen-page-title
                           (getf topic :title)
                           (getf page :title))
                   :intro (getf page :intro)
                   :published-at (getf page :published-at)
                   :url (gen-page-url
                         (getf page :id)
                         (getf page :title))
                   ))))
(defun load-topics ()
  (let ((topics (all-topics-title)))
      (loop for topic in topics
        collect (list
                 :title (getf topic :title)
                 :url (format nil "/topics/~d/~a.html"
                              (getf topic :id)
                              (quri:url-encode (getf topic :title)))
                 ))))

(defun show (id title)
  (let* ((topic (topic-by-id id))
         (page-index (parse-integer (fetch-parameter-with-default "pageIndex" "1")))
         (page-size  (parse-integer (fetch-parameter-with-default "pageSize" "10")))
         (total (getf (total-pages :published t :topic-id id) :total))
         (topic-url (format nil "/topics/~d/~a.html?pageIndex=~~d&pageSize=~~d"
                            (getf topic :id) (quri:url-encode (getf topic :title))))
         (pagination (gen-pagination total page-index page-size topic-url))
         (pages (load-pages page-index page-size topic))
         (topics (load-topics)))
    (render-view #P"topic/show.html"
                 (list :pages pages :topic topic :topics topics :pagers pagination))))
