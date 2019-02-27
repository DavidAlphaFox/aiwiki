(in-package :cl-user)
(defpackage aiwiki.web
  (:use :cl
        :caveman2
        :aiwiki.config
        :aiwiki.view
        :aiwiki.db
        :aiwiki.model
        :datafly
        :sxql)
  (:export :*web*))
(in-package :aiwiki.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Utils

(defun get-request-parameter (parameter)
  "Get a parameter from the request body"
  (cdr (assoc parameter (request-body-parameters *request*) :test #'string=)))

(defun login (username)
  "Log a user in"
  (setf (gethash :username *session*) username))

(defun logout ()
  "Log a user out"
  (setf (gethash :username *session*) nil))

(defun logged-in-p ()
  "Check if a user is currently logged in, return the username"
  (gethash :username *session*))

(defmacro must-be-logged-out (&body body)
  "If user is logged in, return a rendered HTML page with an error message, else elavuate body"
  `(if (logged-in-p)
       (render #P "error.html" (list :username (logged-in-p)
                                     :messages '("You are already logged in. Please log out first")))
       (progn ,@body)))

(defmacro must-be-logged-in (&body body)
  "If user isn't logged in, return a rendered HTML page with an error message, else evaluate body"
  `(if (logged-in-p)
       (progn ,@body)
       (render #P "error.html" (list :username (logged-in-p)
                                     :messages '("You must be logged in to do that")))))

;; wiki

(defmethod 3bmd-wiki:process-wiki-link ((wiki (eql :fsw)) normalized-target formatted-target args stream)
  (if args
   (format stream "<a href=\"/page/~a/~{~a~}\">~a</a>" formatted-target args formatted-target)
   (format stream "<a href=\"/page/~a\">~a</a>" formatted-target formatted-target)))

(defun parse-markdown-page (page)
  (let* ((3bmd-wiki:*wiki-links* t)
         (3bmd-wiki:*wiki-processor* :fsw)
         (content (with-output-to-string (out)
                    (3bmd:parse-string-and-print-to-stream (getf page :content) out))))
    (list* :content content page)))

;;
;; Routing rules

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
  (let ((page (get-latest-page title))
        (version-count (count-pages title)))
    (render #P"page.html" (list* :username (logged-in-p)
                                 :version-count
                                 (if (= version-count 1)
                                     nil
                                     (loop for i from 1 below version-count collect i))
                                 (parse-markdown-page page)))))

(defroute "/page/:title/:number" (&key title number)
  (let* ((number (parse-integer number))
         (page (nth-page-revision title number))
         (version-count (count-pages title)))
    (render #P"page.html" (list* :username (logged-in-p)
                                  :version-count
                                  (if (= version-count 1)
                                      nil
                                      (loop for i below version-count if (not (= i number)) collect i))
                                  (parse-markdown-page page)))))

(defroute "/add_page" ()
  (must-be-logged-in
    (render #P"add_page.html" (list :username (logged-in-p)))))

(defroute ("/add_page" :method :post) ()
  (must-be-logged-in
   (let ((title (get-request-parameter "title"))
         (content (get-request-parameter "content")))
     (add-page title (logged-in-p) content)
     (redirect (concatenate 'string "/page/" title)))))


(defroute "/page_edit/:title" (&key title)
  (must-be-logged-in
    (let ((page (get-latest-page title)))
      (render #P"edit_page.html" (list* :username (logged-in-p)
                                        (parse-markdown-page page))))))

(defroute ("/page_edit/:title" :method :post) (&key title)
  (must-be-logged-in
    (add-page title (logged-in-p) (get-request-parameter "content"))
    (redirect (concatenate 'string "/page/" (quri:url-encode title)))))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
