(in-package :cl-user)
(defpackage aiwiki.view.index
  (:use
   :cl
   :aiwiki.utils.view
   :aiwiki.utils.request
   :aiwiki.utils.pagination
   :aiwiki.model.topic
   :aiwiki.model.page)
  (:export
   :index
   :sitemap))

(in-package :aiwiki.view.index)

;;

(defun load-pages (page-index page-size)
  (let ((pages (pages-with-intro page-index page-size)))
    (loop for page in pages
          collect (let ((topic (topic-title (getf page :topic-id)) ))
                    (list
                     :title (gen-page-title
                             (getf topic :title)
                             (getf page :title))
                     :intro (getf page :intro)
                     :published-at (getf page :published-at)
                     :url (gen-page-url
                           (getf page :id)
                           (getf page :title))
                     )))))

(defun load-topics ()
  (let ((topics (all-topics-title)))
      (loop for topic in topics
        collect (list
                 :title (getf topic :title)
                 :url (format nil "/topics/~d/~a.html"
                              (getf topic :id)
                              (quri:url-encode (getf topic :title)))
                 ))))



(defun index ()
  (let* ((page-index (parse-integer (fetch-parameter-with-default "pageIndex" "1")))
         (page-size  (parse-integer (fetch-parameter-with-default "pageSize" "10")))
         (total (getf (total-pages :published t) :total))
         (topics (load-topics))
         (pages (load-pages page-index page-size))
         (pagination (gen-pagination total page-index page-size "/?pageIndex=~d&pageSize=~d")))
    (render-view #P"index.html"
                 (list :index t :pages pages :topics topics :pagers pagination))))

(defun load-pages-sitemap ()
  (let ((pages (group-pages-month)))
    (loop for page in pages
          collect (list :url
                        (gen-sitemap-url "pages" :month (getf page :month))))))
(defun sitemap ()
  (let* ((last-mod (local-time:now))
        (topic-sitemap (list :url (gen-sitemap-url "topics")))
        (page-sitemaps (load-pages-sitemap))
        (sitemaps (list* topic-sitemap page-sitemaps)))
    (render-xml #P"sitemap/index.xml"
                 (list :last-mod last-mod :sitemaps sitemaps))))
