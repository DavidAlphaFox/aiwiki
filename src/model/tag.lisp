
(in-package :cl-user)

(defpackage aiwiki.model.tag
  (:use :cl :sxql)
  (:import-from
   :aiwiki.db
   :db
   :fetch-all
   :execute-transaction
   )
  (:import-from
   :datafly
   :execute)
  (:export
   :create-tag-table
   :add-tag
   :all-tags))

(in-package :aiwiki.model.tag)

;;; Page model

(defun create-tag-table ()
  "Create tag table if it doesn't exist yet."
  (with-connection (db)
    (execute
     (create-table (:tags :if-not-exists t)
         ((id :type 'serial :primary-key t)
          (title :type 'text :not-null t :unique t))))))

(defun add-tag (title)
  (execute-transaction
   (db)
   (insert-into :tags
     (set= :title title)
     (returning :id))))

(defun all-tags ()
  (fetch-all
      (db)
    (select (:id :title)
      (from :tags))))
