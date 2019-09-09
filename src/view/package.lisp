(in-package :cl-user)

(defpackage aiwiki.view
  (:use
   :cl
   :caveman2)
  (:import-from
   :caveman2
   :<app>
   :throw-code)
  (:export
   :*web*))

(in-package aiwiki.view)
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

(defroute ("/" :method :GET) ()
  (with-uncaught-handler (aiwiki.view.index:index-html)))

(defroute ("/pages.json" :method :GET) () (aiwiki.view.page:index-json))
(defroute ("/pages/create.json" :method :POST) () (aiwiki.view.page:create-json))
(defroute ("/pages/:id/:title.:formatter" :method :GET) (&key id title formatter)
  (with-uncaught-handler
    (with-response-format formatter
      (:json (aiwiki.view.page:show-json id title)
       :html (aiwiki.view.page:show-html id title)))))

;; Error pages
(defmethod on-exception ((app <web>) (code (eql 500)))
  (declare (ignore app code))
  (merge-pathnames #P"errors/500.html"
                   aiwiki.base.config:*template-directory*))

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app code))
  (merge-pathnames #P"errors/404.html"
                   aiwiki.base.config:*template-directory*))
