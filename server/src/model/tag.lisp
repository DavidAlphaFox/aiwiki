
(in-package :cl-user)

(defpackage aiwiki.model.tag
  (:use :cl :sxql)
  (:import-from
   :aiwiki.base.db
   :db
   :fetch-all
   :fetch-one)
  (:export
   :add-tag
   :all-tags))

(in-package :aiwiki.model.tag)

(defun add-tag (title)
  (fetch-one (db)
    (insert-into :tags
      (set= :title title)
      (returning :id))))

(defun all-tags ()
  (fetch-all (db)
    (select (:id :title)
      (from :tags))))
