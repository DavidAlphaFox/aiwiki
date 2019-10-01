(in-package :cl-user)
(defpackage aiwiki.utils.pagination
  (:use
   :cl)
  (:export
   :gen-pagination))

(in-package :aiwiki.utils.pagination)

(defun gen-prev-next (link page-index page-size with-prev with-next)
  (let ((prev (format nil link (- page-index 1) page-size))
        (next (format nil link (+ page-index 1) page-size)))
    (list (list :title "前一页" :url prev :enable with-prev)
          (list :title "后一页" :url next :enable with-next))))


(defun gen-pagination (total page-index page-size link)
  (let ((page-total (ceiling (/ total page-size))))
    (cond
      ((and (< page-index page-total) (> page-index 1)) (gen-prev-next link page-index t t))
      ((> page-index 1) (gen-prev-next link page-index page-size t nil))
      ((< page-index page-total) (gen-prev-next link page-index page-size nil t))
      (t '()))))
