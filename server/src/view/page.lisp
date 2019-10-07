(in-package :cl-user)
(defpackage aiwiki.view.page
  (:use
   :cl
   :caveman2
   :aiwiki.utils.view
   :aiwiki.utils.markdown
   :aiwiki.utils.request
   :aiwiki.model.page
   :aiwiki.model.topic)
  (:export
   :show
   :sitemap))

(in-package :aiwiki.view.page)

;;
;; Routing rules
;;

(defun load-pages (month)
  (let ((pages (pages-under-month month)))
    (loop for page in pages
          collect (list
                   :freq "monthly"
                   :url (gen-page-url
                         (getf page :id)
                         (getf page :title)
                         :with-host t)))))

(defun sitemap ()
  (let* ((month (fetch-parameter "date"))
         (urls (load-pages month)))
    (render-xml #P"sitemap/urlset.xml" (list :urls urls))))

(defun show (id title)
  (let* ((page (page-by-id id))
         (topic (topic-title (getf page :topic-id)))
         (canonical-url (gen-page-url
                         (getf page :id)
                         (getf page :title)))
         (page-title (gen-page-title
                      (getf topic :title)
                      (getf page :title))))
    (setf (getf page :title) page-title)
    (render-view #P"page/show.html"
                 (parse-page (list* :topic topic :canonical-url canonical-url page)))
    ))
