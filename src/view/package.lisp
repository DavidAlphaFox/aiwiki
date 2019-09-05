(in-package :cl-user)

(defpackage aiwiki.web
  (:use
   :cl
   :caveman2
   :aiwiki.web.user
   :aiwiki.web.page)
  (:export
   :*web*
   ))
(in-package aiwiki.web)
;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)
(syntax:use-syntax :annot)

(defroute "/" ()
  (get-index))

(defroute "/login" ()
  (get-login))

(defroute ("/login" :method :post) ()
  (post-login))

(defroute "/logout" ()
  (get-logout))

(defroute "/register" ()
  (get-register))

(defroute ("/register" :method :post) ()
  (post-register))
;; pages

(defroute "/page/:title" (&key title)
  (get-page title))

(defroute "/page/:title/:number" (&key title number)
  (get-version-page title number))

(defroute "/add_page" ()
  (get-add-page))

(defroute ("/add_page" :method :post) ()
  (post-add-page))


(defroute "/page_edit/:title" (&key title)
  (get-edit-page title))

(defroute ("/page_edit/:title" :method :post) (&key title)
  (post-edit-page title))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))

