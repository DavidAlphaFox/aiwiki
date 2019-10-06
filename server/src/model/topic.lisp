
(in-package :cl-user)

(defpackage aiwiki.model.topic
  (:use :cl :sxql)
  (:import-from
   :aiwiki.base.db
   :db
   :fetch-all
   :fetch-one)
  (:export
   :all-topics-title
   :topic-title
   :topic-by-id))

(in-package :aiwiki.model.topic)

(defun all-topics-title ()
  (fetch-all (db)
    (select (:id :title)
      (from :topics))))

(defun topic-title (id)
  (fetch-one (db)
    (select (:id :title)
      (from :topics)
      (where (:= :id id)))))

(defun topic-by-id (id)
  (fetch-one (db)
    (select :*
      (from :topics)
      (where (:= :id id)))))
