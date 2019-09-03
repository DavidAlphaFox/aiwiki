;;;; model.lisp

(in-package :cl-user)

(defpackage aiwiki.model.page
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
   :create-page-table
   :add-page
   :get-page
   :pages-with-brief
   ))

(in-package :aiwiki.model.page)

;;; Page model

(defun create-page-table ()
  "Create page table if it doesn't exist yet."
  (with-connection (db)
    (execute
     (create-table (:pages :if-not-exists t)
         ((id :type 'serial :primary-key t)
          (title :type 'text :not-null t :unique t)
          (brief :type 'text :not-null t)
          (content :type 'text :not-null t)
          (published :type 'boolean :not-null t :default 'false)
          (date :type 'timestamp :not-null t))))))

(defun add-page (title brief content published)
  (with-transaction (db)
    (execute
     (insert-into :pages
       (set= :title title
             :brief brief
             :content content
             :published published
             :date (local-time:now))
       (returning :id)))))


(defun get-page (title)
  (with-connection (db)
    (retrieve-one
     (select :*
       (from :pages)
       (where (:= :title title))))))

(defun pages-with-brief (pageIndex pageSize)
  (let ( (offset (* (- pageIndex 1) pageSize)))
    (with-connection (db)
      (retrieve-all
       (select (:id :title :brief)
               (from :pages)
               (offset offset)
               (limit pageSize))))))
