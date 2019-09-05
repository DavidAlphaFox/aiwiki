(in-package :cl-user)
(defpackage aiwiki.view.index
  (:use
   :cl
   :caveman2
   :aiwiki.base.view
   :aiwiki.view.utils
   :aiwiki.model.tag
   :aiwiki.model.page)
  (:export
   :action-index))

(in-package :aiwiki.view.index)

;;
;; Routing rules

(defun gen-tags (tags)
  (loop for tag in tags
        collect (list
                 :title (getf tag :title)
                 :url (format nil "/tag/~d/~S.html"
                              (getf tag :id)
                              (quri:url-encode (getf tag :title)))
                 )))

(defun gen-pages (pages)
  (loop for page in pages
        collect (list
                 :title (getf page :title)
                 :intro (getf page :intro)
                 :url (format nil "/page/~d/~S.html"
                              (getf page :id)
                              (quri:url-encode (getf page :title))
                 ))))


(defun load-pages ()
  (let ((pageIndex (fetch-request-parameter-with-default "pageIndex" "1"))
        (pageSize (fetch-request-parameter-with-default "pageSize" "10")))
    (gen-pages (pages-with-intro
                (parse-integer pageIndex)
                (parse-integer pageSize)))))

(defun load-tags ()
  (let ((tags (all-tags)))
    (gen-tags tags)))

(defun action-index ()
  (let ((tags (load-tags))
         (pages (load-pages)))
    (render #P"index.html"
            (list :pages pages :tags tags))))
