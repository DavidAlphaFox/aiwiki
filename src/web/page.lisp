(in-package :cl-user)
(defpackage aiwiki.web
  (:use
   :cl
   :caveman2
   :aiwiki.config
   :aiwiki.view
   :aiwiki.db
   :aiwiki.model
   :aiwiki.web.utils
   :datafly
   :sxql)
  (:export
   :post-edit-page
   :get-edit-page
   :post-add-page
   :get-add-page
   :get-version-page
   :get-page))

(defun get-edit-page(title)
  (must-be-logged-in
   (let ((page (get-latest-page title)))
     (render #P"edit_page.html" (list* :username (logged-in-p)
                                       (parse-markdown-page page))))))
(defun post-edit-page(title)
  (must-be-logged-in
   (add-page title (logged-in-p) (get-request-parameter "content"))
   (redirect (concatenate 'string "/page/" (quri:url-encode title)))))

(defun post-add-page ()
  (must-be-logged-in
   (let ((title (get-request-parameter "title"))
         (content (get-request-parameter "content")))
     (add-page title (logged-in-p) content)
     (redirect (concatenate 'string "/page/" title)))))
(defun get-add-page ()
  (must-be-logged-in
   (render #P"add_page.html" (list :username (logged-in-p)))))
(defun get-version-page (title number)
  (let* ((number (parse-integer number))
         (page (nth-page-revision title number))
         (version-count (count-pages title)))
    (render #P"page.html" (list* :username (logged-in-p)
                                 :version-count
                                 (if (= version-count 1)
                                     nil
                                     (loop for i below version-count if (not (= i number)) collect i))
                                 (parse-markdown-page page)))))
(defun get-page (title)
  (let ((page (get-latest-page title))
        (version-count (count-pages title)))
    (render #P"page.html" (list* :username (logged-in-p)
                                 :version-count
                                 (if (= version-count 1)
                                     nil
                                     (loop for i from 1 below version-count collect i))
                                 (parse-markdown-page page)))))
