(in-package :cl-user)

(defpackage aiwiki.app
  (:use
   :cl
   :caveman2)
  (:import-from
   :caveman2
   :<app>
   :throw-code)
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
(defroute ("/api/pages.json" :method :GET) () (aiwiki.api.page:index))
(defroute ("/api/pages/:id.json" :method :GET) (&key id) (aiwiki.api.page:show id))
(defroute ("/api/pages/:id.json" :method :POST) (&key id) (aiwiki.api.page:update id))

;; pages

(defroute ("/pages/:id/:title.:formatter" :method :GET) (&key id title formatter)
  (with-uncaught-handler
    (with-response-format formatter
      (:html (aiwiki.view.page:show id title)))))

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
