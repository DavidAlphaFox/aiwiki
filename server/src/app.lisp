(in-package :cl-user)

(defpackage aiwiki.app
  (:use
   :cl
   :caveman2)
  (:import-from
   :caveman2
   :<app>
   :throw-code)
  (:import-from
   :aiwiki.utils.auth
   :must-be-logged-in)
  (:export
   :*web*))

(in-package aiwiki.app)
;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)
;;(syntax:use-syntax :annot)

(defmacro with-uncaught-handler (&body body)
  `(handler-case ,@body
     (t (c)
       (format t "~a~&" c)
       (throw-code 500))))

(defmacro with-response-format (formatter response-list)
  (let ((cond-response-list
          (loop for (expect-formatter express)
                on response-list
                by #'cddr
                collect `((string-equal (string ,expect-formatter) ,formatter) ,express))))
    `(cond ,@cond-response-list
           (t (caveman2:throw-code 500)))))
;; api
(defroute ("/api/login.json" :method :POST) () (aiwiki.api.auth:login))
(defroute ("/api/password/update.json" :method :POST) () (must-be-logged-in (aiwiki.api.auth:update-password)))
(defroute ("/api/token/verify.json" :method :GET) () (must-be-logged-in (aiwiki.api.auth:verify-token)))
(defroute ("/api/site.json" :method :GET) () (must-be-logged-in (aiwiki.api.site:index)))
(defroute ("/api/site.json" :method :POST) () (must-be-logged-in (aiwiki.api.site:update)))
(defroute ("/api/topics.json" :method :GET) () (must-be-logged-in (aiwiki.api.topic:index)))
(defroute ("/api/pages.json" :method :GET) () (must-be-logged-in (aiwiki.api.page:index)))
(defroute ("/api/pages.json" :method :POST) () (must-be-logged-in (aiwiki.api.page:create)))
(defroute ("/api/pages/:id.json" :method :GET) (&key id) (must-be-logged-in (aiwiki.api.page:show id)))
(defroute ("/api/pages/:id.json" :method :POST) (&key id) (must-be-logged-in (aiwiki.api.page:update id)))


;; pages
(defroute ("/pages/:id/:title.:formatter" :method :GET) (&key id title formatter)
  (with-uncaught-handler
    (with-response-format formatter
      (:html (aiwiki.view.page:show id title)))))
(defroute ("/pages/sitemap.xml" :method :GET) () (with-uncaught-handler (aiwiki.view.page:sitemap)))
(defroute ("/topics/:id/:title.:formatter" :method :GET) (&key id title formatter)
  (with-uncaught-handler
    (with-response-format formatter
      (:html (aiwiki.view.topic:show id title)))))
(defroute ("/topics/sitemap.xml" :method :GET) () (with-uncaught-handler (aiwiki.view.topic:sitemap)))
(defroute ("/sitemap.xml" :method :GET) () (with-uncaught-handler (aiwiki.view.index:sitemap)))
(defroute ("/rss.xml" :method :GET) () (with-uncaught-handler (aiwiki.view.index:rss)))
(defroute ("/" :method :GET) () (with-uncaught-handler (aiwiki.view.index:index)))



;; Error pages
(defmethod on-exception ((app <web>) (code (eql 500)))
  (declare (ignore app code))
  (setf (getf (response-headers *response*) :content-type) "text/html")
  (merge-pathnames #P"errors/500.html"
                   aiwiki.base.config:*template-directory*))

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app code))
  (setf (getf (response-headers *response*) :content-type) "text/html")
  (merge-pathnames #P"errors/404.html"
                   aiwiki.base.config:*template-directory*))
