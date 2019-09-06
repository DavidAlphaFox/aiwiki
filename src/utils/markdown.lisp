(in-package :cl-user)
(defpackage aiwiki.utils.markdown
  (:use
   :cl)
  (:export
   :parse-page))

(in-package :aiwiki.utils.markdown)

;; wiki

(defmethod 3bmd-wiki:process-wiki-link ((wiki (eql :fsw)) normalized-target formatted-target args stream)
  (let (encode-target (quri:url-encode title))
    (if args
      (format stream "<a href=\"/page/~a/~{~a~}\">~a</a>" encode-target args formatted-target)
      (format stream "<a href=\"/page/~a\">~a</a>" encode-target formatted-target))
    ))

(defun parse-page (page)
  (let* ((3bmd-wiki:*wiki-links* t)
         (3bmd-wiki:*wiki-processor* :fsw)
         (content (with-output-to-string (out)
                    (3bmd:parse-string-and-print-to-stream (getf page :content) out))))
    (list* :content content page)))
