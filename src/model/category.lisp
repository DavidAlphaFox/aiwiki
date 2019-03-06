(in-package :cl-user)
(defpackage aiwiki.model.category
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
   :all-categories
   ))
(defun all-categories ()
  (with-connecion (db)
    (retrieve-all
     (select (:title)
       (from :category)
       (order-by (:asc :id)))
     )))
