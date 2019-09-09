(in-package :cl-user)
(defpackage aiwiki.base.db
  (:use :cl)
  (:import-from
   :aiwiki.base.config
   :config)
  (:import-from
   :datafly
   :*connection*
   :retrieve-all
   :retrieve-one
   :execute)
  (:import-from
   :cl-dbi
   :connect-cached)
  (:export
   :connection-settings
   :db
   :with-connection
   :with-transaction
   :fetch-one
   :fetch-all
   :execute-transaction
   :fetch-pagination
   ))

(in-package :aiwiki.base.db)

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

(defmacro fetch-pagination (ptable pcols pindex psize)
  (let ((poffset (gensym)))
    `(let ((,poffset (* (- ,pindex 1) ,psize)))
       (fetch-all (db)
         (sxql:select ,pcols
           (sxql:from ,ptable)
           (sxql:offset ,poffset)
           (sxql:limit ,psize))))))
