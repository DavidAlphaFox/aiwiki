(in-package :cl-user)
(defpackage aiwiki.db
  (:use :cl)
  (:import-from :aiwiki.config
                :config)
  (:import-from
   :datafly
   :*connection*
   :connect-cached
   :retrieve-all
   :retrieve-one
   :execute)
  (:export
   :connection-settings
   :db
   :with-connection
   :with-transaction
   :fetch-one
   :fetch-all
   :execute-transaction
   ))

(in-package :aiwiki.db)

(defun connection-settings (&optional (db :maindb))
  (cdr (assoc db (config :databases))))

(defun db (&optional (db :maindb))
  (apply #'connect-cached (connection-settings db)))

(defmacro with-connection (conn &body body)
  `(let ((*connection* ,conn))
     ,@body))

(defmacro with-transaction (conn &body body)
  `(let ((*connection* ,conn))
     (cl-dbi:with-transaction *connection*
       ,@body)))

(defmacro fetch-one (conn &body body)
  `(with-transaction ,conn
     (retrieve-one ,@body)))
(defmacro fetch-all (conn &body body)
  `(with-transaction ,conn
     (retrieve-all ,@body)))

(defmacro execute-transaction (conn &body body)
  `(with-transaction ,conn
     (execute ,@body)))
