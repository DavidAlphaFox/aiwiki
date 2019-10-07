(in-package :cl-user)
(defpackage aiwiki.utils.view
  (:use :cl)
  (:import-from
   :aiwiki.base.config
   :config)
  (:import-from
   :aiwiki.base.view
   :render
   :render-xml
   :render-json)
  (:import-from
   :aiwiki.model.site
   :fetch-site)
  (:export
   :gen-page-title
   :gen-page-url
   :gen-topic-url
   :gen-sitemap-url
   :render-view
   :render-json
   :render-xml))

(in-package :aiwiki.utils.view)

(defmacro gen-page-title (topic-title page-title)
  `(format nil "[~a]~a" ,topic-title ,page-title))
(defmacro gen-page-url (page-id page-title &key with-host)
  (if with-host
      `(format nil "~a://~a/pages/~d/~a.html"
               (config :scheme)
               (config :host)
               ,page-id
               (quri:url-encode ,page-title))
      `(format nil "/pages/~d/~a.html"
               ,page-id
               (quri:url-encode ,page-title))))
(defmacro gen-topic-url (topic-id topic-title &key with-host)
  (if with-host
      `(format nil "~a://~a/topics/~d/~a.html"
               (config :scheme)
               (config :host)
               ,topic-id
               (quri:url-encode ,topic-title))
      `(format nil "/topics/~d/~a.html"
               ,topic-id
               (quri:url-encode ,topic-title))))

(defmacro gen-sitemap-url (loc &key month)
  `(if ,month
       (format nil "~a://~a/~a/sitemap.xml?date=~a"
               (config :scheme)
               (config :host)
               ,loc
               (quri:url-encode ,month))
       (format nil "~a://~a/~a/sitemap.xml"
               (config :scheme)
               (config :host)
               ,loc)))

(defun render-view (template-path &optional env)
  (let ((site (fetch-site)))
    (render template-path (list* :site site env))))
