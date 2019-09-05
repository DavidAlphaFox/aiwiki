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
   :fetch-links
   :total-links
   ))

(in-package :aiwiki.model.link)
(defun add-link (title url summary)
  (fetch-one (db)
    (insert-into :links
      (set= :title title
            :url url
            :summary summary
            )
      (returning :id))))

(defun fetch-links (pageIndex pageSize)
  (let ( (pageOffset (* (- pageIndex 1) pageSize)))
    (fetch-all (db)
      (select (:id :title :url :summary)
        (from :links)
        (offset pageOffset)
        (limit pageSize)))))

(defun total-links ()
  (fetch-one (db)
    (select
        (:as (:count :id) :total)
      (from :links))))
