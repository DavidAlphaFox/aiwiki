(in-package :cl-user)

(defpackage aiwiki.web
  (:use
   :cl
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
  (render #P"index.html" (list :username (logged-in-p)
                               :pages (get-latest-pages-titles))))

(defroute "/login" ()
  (must-be-logged-out (render #P"login.html")))

(defroute ("/login" :method :post) ()
  (must-be-logged-out
    (multiple-value-bind (password-correct username-found)
        (authenticate-user (get-request-parameter "username")
                           (get-request-parameter "password"))
      (cond (password-correct (progn (login (get-request-parameter "username"))
                                     (redirect "/")))
            ((not username-found) (render #P "login.html" (list :messages '("Wrong username or email"))))
            (t (render #P "login.html" (list :messages '("Wrong password!"))))))))

(defroute "/logout" ()
  (setf (gethash :username *session*) nil)
  (redirect "/"))

(defroute "/register" ()
  (must-be-logged-out (render #P "register.html")))

(defroute ("/register" :method :post) ()
  (must-be-logged-out
    (let ((username (get-request-parameter "username"))
          (email (get-request-parameter "email"))
          (password (get-request-parameter "password"))
          (password2 (get-request-parameter "password2")))
      (cond ((find-user username)
             (render #P "register.html" (list :username (logged-in-p)
                                              :messages '("username already registered"))))
            ((find-user email)
             (render #P "register.html" (list :username (logged-in-p)
                                              :messages '("email already registered"))))
            ((not (string= password password2))
             (render #P "register.html" (list :username (logged-in-p)
                                              :messages '("Passwords do not match"))))
            (t (add-user username email password)
               (login username)
               (redirect "/"))))))

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

