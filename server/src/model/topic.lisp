
(in-package :cl-user)

(defpackage aiwiki.model.topic
  (:use :cl :sxql)
  (:import-from
   :aiwiki.base.db
   :db
   :fetch-all
   :fetch-one)
  (:export
   :all-topics-title))

(in-package :aiwiki.model.topic)

(defun all-topics-title ()
  (fetch-all (db)
    (select (:id :title)
      (from :topics))))
