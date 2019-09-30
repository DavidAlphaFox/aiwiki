(in-package :cl-user)

(defpackage aiwiki.model.user
  (:use :cl :sxql)
  (:import-from
   :aiwiki.base.db
   :db
   :fetch-one
   :fetch-all
   :execute-transaction
   :fetch-pagination
   :to-db-boolean)
  (:export
   :find-user-by-username
   :add-user
   ))

(in-package :aiwiki.model.user)

(defun find-user-by-username (username)
  (fetch-one (db)
    (select :*
      (from :users)
      (where (:= :username username)))))

(defun add-user (username password)
  (fetch-one (db)
     (insert-into :users
       (set= :username username
             :password (cl-pass:hash password))
       (returning :id))))
