(in-package :cl-user)
(defpackage aiwiki.utils.markdown
  (:use
   :cl)
  (:import-from
   :aiwiki.model.site
   :fetch-utm)
  (:export
   :parse-page))

(in-package :aiwiki.utils.markdown)

;; wiki

(defun build-wiki-url (url utm)
  (let* ((u (quri:uri url))
         (q (quri:uri-query-params u)))
    (if q
        (setf (quri:uri-query-params u) (append q utm))
        (setf (quri:uri-query-params u) utm))
    u))

(defmethod 3bmd-wiki:process-wiki-link ((wiki (eql :fsw)) normalized-target formatted-target args stream)
  (if args
      (let* ((utm (fetch-utm))
             (utm-source (access:access utm :utm-source))
             (utm-medium (access:access utm :utm-medium))
             (utm-campaign (access:access utm :utm-campaign))
             (u (build-wiki-url (car args) (list (cons "utm_source"  (quri:url-encode utm-source))
                                                 (cons "utm_medium"  (quri:url-encode utm-medium))
                                                 (cons "utm_campaign"  (quri:url-encode utm-campaign))))))
        (format stream "<a href=\"~a\">~a</a>" (quri:render-uri u) formatted-target))
      (let ((title (quri:url-encode normalized-target)))
        (format stream "<a href=\"/wiki/~a\">~a</a>" title formatted-target))))

(defun parse-page (page)
  (let* ((3bmd-wiki:*wiki-links* t)
         (3bmd-wiki:*wiki-processor* :fsw)
         (content (with-output-to-string (out)
                    (let ((3bmd-code-blocks:*code-blocks* t)
                          (3bmd:*smart-quotes* t))
                      (3bmd:parse-string-and-print-to-stream (getf page :content) out)))))
    (list* :rendered-content content page)))
