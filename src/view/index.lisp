(in-package :cl-user)
(defpackage aiwiki.view.index
  (:use
   :cl
   :caveman2
   :aiwiki.base.view
   :aiwiki.model.tag)
  (:export
   :action-index))

(in-package :aiwiki.view.index)

;;
;; Routing rules

(defun gen-tags (tags)
  (loop for tag in tags
        collect (list
                 :title (getf tag :title)
                 :url (format nil "/tags/~S.html?id=~d"
                              (quri:url-encode (getf tag :title))
                              (getf tag :id))
                 )))

(defun action-index ()
  (let ((tags (all-tags)))
    (render #P"index.html"
            (list :tags (gen-tags tags)))))

