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
   :show))

(in-package :aiwiki.view.page)

;;
;; Routing rules


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
