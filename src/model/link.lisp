(in-package :cl-user)

(defpackage aiwiki.model.link
  (:use :cl :sxql)
  (:import-from
   :aiwiki.db
   :db
   :fetch-one
   :fetch-all)
  (:export
   :add-link
   ))

(in-package :aiwiki.model.link)
(defun add-link (title url summary)
  (fetch-one (db)
    (insert-into :links
      (set= :title title
            :url url
            :summary summary
            )
      (return :id))))
(defun)
