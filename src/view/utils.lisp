(in-package :cl-user)
(defpackage aiwiki.view.utils
  (:use
   :cl
   :caveman2
   :aiwiki.base.view)
  (:export
   :fetch-request-parameter
   :fetch-request-parameter-with-default
   :parse-markdown-page))

(in-package :aiwiki.view.utils)

;;
;; Utils

(defun fetch-request-parameter-with-default (parameter defaultValue)
  (let ((matched (assoc parameter (request-parameters *request*) :test #'string=)))
    (cond ((equal matched nil) defaultValue)
          (t (cdr matched)))))

(defun fetch-request-parameter (parameter)
  "Get a parameter from the request body"
  (cdr (assoc parameter (request-parameters *request*) :test #'string=)))

;; wiki

(defmethod 3bmd-wiki:process-wiki-link ((wiki (eql :fsw)) normalized-target formatted-target args stream)
  (let (encode-target (quri:url-encode title))
    (if args
      (format stream "<a href=\"/page/~a/~{~a~}\">~a</a>" encode-target args formatted-target)
      (format stream "<a href=\"/page/~a\">~a</a>" encode-target formatted-target))
    ))

(defun parse-markdown-page (page)
  (let* ((3bmd-wiki:*wiki-links* t)
         (3bmd-wiki:*wiki-processor* :fsw)
         (content (with-output-to-string (out)
                    (3bmd:parse-string-and-print-to-stream (getf page :content) out))))
    (list* :content content page)))



