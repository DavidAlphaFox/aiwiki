;;;; model.lisp

(in-package :cl-user)

(defpackage aiwiki.model.user
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
   :create-user-table
   :find-user
   :add-user
   :authenticate-user
   ))

(in-package :aiwiki.model.user)

;;; User model

(defun create-user-table ()
  "Create user table if it doesn't exist yet."
  (with-connection (db)
    (execute
     (create-table (:user :if-not-exists t)
         ((id :type 'serial :primary-key t)
          (username :type 'text :not-null t :unique t)
          (email :type 'text :not-null t :unique t)
          (password :type 'text :not-null t))))))

(defun add-user (username email password)
  "add user record to database."
  (with-connection (db)
    (execute
     (insert-into :user
       (set= :username username
             :email email
             :password (cl-pass:hash password))))))

(defun find-user-by-username (username)
  "lookup user record by username."
  (with-connection (db)
    (retrieve-one
     (select :*
       (from :user)
       (where (:= :username username))))))

(defun find-user-by-email (email)
  "lookup user record by email."
  (with-connection (db)
    (retrieve-one
     (select :* (from :user)
             (where (:= :email email))))))

(defun find-user (username-or-email)
  "lookup user record by username or email."
  (or (find-user-by-username username-or-email)
      (find-user-by-email username-or-email)))

(defun authenticate-user (username-or-email password)
  "Lookup user record and validate password. Returns two values:
   1st value, was password correct T or NIL
   2nd value, was user found, T or NIL
Example:
   (VALUES NIL NIL) -> user not found
   (VALUES NIL T) -> user found, but wrong password
   (VALUES T T) -> password correct"
  (let ((password-hash (getf (find-user username-or-email) :password)))
    (if password-hash 
        (values (cl-pass:check-password password password-hash) t)
        (values nil nil))))
