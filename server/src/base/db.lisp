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
   :to-db-boolean
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

(defmacro fetch-pagination (ptable pcols pcond pindex psize)
  (let ((poffset (gensym)))
    (if pcond
        `(let ((,poffset (* (- ,pindex 1) ,psize)))
           (fetch-all (db)
             (sxql:select ,pcols
               (sxql:from ,ptable)
               (sxql:where ,pcond)
               (sxql:order-by (:desc :id))
               (sxql:offset ,poffset)
               (sxql:limit ,psize))))
        `(let ((,poffset (* (- ,pindex 1) ,psize)))
           (fetch-all (db)
             (sxql:select ,pcols
               (sxql:from ,ptable)
               (sxql:order-by (:desc :id))
               (sxql:offset ,poffset)
               (sxql:limit ,psize))))
        )))

(defun to-db-boolean (v)
  (if (eq t v) "true" "false"))
