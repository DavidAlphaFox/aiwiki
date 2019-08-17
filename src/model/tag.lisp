
(in-package :cl-user)

(defpackage aiwiki.model.tag
  (:use :cl :sxql)
  (:import-from
   :aiwiki.db
   :db
   :with-connection
   :with-transaction)
  (:import-from
   :datafly
   :execute
   :retrieve-all
   :retrieve-one)
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
  (with-transaction (db)
    (execute
     (insert-into :tags
       (set= :title title)
       ))))

(defun all-tags ()
  (with-transaction (db)
    (retrieve-all
     (select (:id :title)
       (from :tags)
       ))))
