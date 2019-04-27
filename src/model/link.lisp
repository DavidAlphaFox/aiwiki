(in-package :cl-user)

(defpackage aiwiki.model.link
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
   :add-link
   ))

(in-package :aiwiki.model.link)
(defun add-link (title url summary)
  (with-connection (db)
    (execute
     (insert-into :links
                  (set= :title title
                        :url url
                        :summary summary
                        :created_at (local-time:now)
                        ))))
