(in-package :cl-user)
(defpackage aiwiki.view.index
  (:use
   :cl
   :aiwiki.utils.view
   :aiwiki.utils.request
   :aiwiki.utils.pagination
   :aiwiki.model.tag
   :aiwiki.model.topic
   :aiwiki.model.page)
  (:export
   :index))

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
                     :topic topic
                     :published-at (getf page :published-at)
                     :url (gen-page-url
                           (getf page :id)
                           (getf page :title))
                     )))))

(defun load-tags ()
  (let ((tags (all-tags)))
      (loop for tag in tags
        collect (list
                 :title (getf tag :title)
                 :url (format nil "/tag/~d/~a.html"
                              (getf tag :id)
                              (quri:url-encode (getf tag :title)))
                 ))))



(defun index ()
  (let* ((page-index (parse-integer (fetch-parameter-with-default "pageIndex" "1")))
         (page-size  (parse-integer (fetch-parameter-with-default "pageSize" "10")))
         (total (getf (total-pages :published t) :total))
         (tags (load-tags))
         (pages (load-pages page-index page-size))
         (pagination (gen-pagination total page-index page-size "/?pageIndex=~d&pageSize=~d")))
    (render-view #P"index.html"
                 (list :index t :pages pages :tags tags :pagers pagination))))
