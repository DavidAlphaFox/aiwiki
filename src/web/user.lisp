(in-package :cl-user)
(defpackage aiwiki.web.user
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
   :get-index
   :get-login
   :post-login
   :get-logout
   :get-register
   :post-register))
(in-package :aiwiki.web.user)

;;
;; Routing rules

(defun get-index ()
  (render #P"index.html" (list :username (logged-in-p)
                               :pages (get-latest-pages-titles))))

(defun get-login ()
  (must-be-logged-out (render #P"login.html")))

(defun post-login ()
  (must-be-logged-out
    (multiple-value-bind (password-correct username-found)
        (authenticate-user (get-request-parameter "username")
                           (get-request-parameter "password"))
      (cond (password-correct (progn (login (get-request-parameter "username"))
                                     (redirect "/")))
            ((not username-found) (render #P "login.html" (list :messages '("Wrong username or email"))))
            (t (render #P "login.html" (list :messages '("Wrong password!"))))))))

(defun get-logout ()
  (setf (gethash :username *session*) nil)
  (redirect "/"))

(defun get-register ()
  (must-be-logged-out (render #P "register.html")))

(defun post-register ()
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

