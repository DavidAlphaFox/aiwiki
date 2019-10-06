;;;; model.lisp

(in-package :cl-user)

(defpackage aiwiki.model.page
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
   :page-by-title
   :page-by-id
   :pages-with-intro
   :pages-with-published
   :total-pages
   :add-page
   :update-page
   :publish-page
   ))

(in-package :aiwiki.model.page)

;;; Page model

(defmacro update-action (id fields)
  `(update :pages
           (set= ,@fields)
           (where (:= :id ,id))))

(defmacro find-action (fields cond-statement)
  `(select ,@fields
     (from :pages)
     (where ,cond-statement)))

(defun page-by-title (title)
  (fetch-one (db)
    (find-action (:*) (:= :title title))))

(defun page-by-id (id)
  (fetch-one (db)
    (find-action (:*) (:= :id id))))

(defun add-page (title intro content topic-id)
  (fetch-one (db)
    (insert-into :pages
      (set=
       :title title
       :intro intro
       :content content
       :topic_id topic-id)
      (returning :id))))

(defun update-page (id title intro content published topic-id)
  (execute-transaction (db)
    (let ((r (find-action (:published) (:= :id id))))
      (if (and (not (access:access r :published)) published)
          (update-action id (:title title :intro intro :topic_id topic-id
                             :content content :published (to-db-boolean published)))
          (update-action id (:title title :intro intro :published_at (:raw "now() AT TIME ZONE 'UTC'")
                             :content content :topic_id topic-id
                             :published (to-db-boolean published)))))))

(defun publish-page (id published)
  (execute-transaction (db)
    (let ((r (find-action (:published) (:= :id id))))
      (if (and (access:access r :published) published)
          (update-action id (:published (to-db-boolean published)))
          (update-action id (:published (to-db-boolean published)
                             :published_at (:raw "now() AT TIME ZONE 'UTC'")))))))


(defun total-pages (&key published topic-id)
  (fetch-one (db)
    (let ((cond-statement
            (cond ((and published topic-id)
              (where (:and
                      (:= :published (to-db-boolean published))
                      (:= :topic_id topic-id))))
            (published
             (where (:= :published (to-db-boolean published))))
            (topic-id
             (where (:= :topic_id topic-id)))
            (t nil))))
      (if cond-statement
          (select ((:as (:count :id) :total))
            (from :pages)
            cond-statement)
          (select ((:as (:count :id) :total))
            (from :pages))))))

(defmacro pages-with-intro-cond (topic-id)
  `(if ,topic-id
       (list :and
             (list := :published "true")
             (list := :topic_id ,topic-id))
       '(:= :published "true")))

(defun pages-with-intro (page-index page-size &key topic-id)
  (fetch-pagination :pages
                    ((:id :title :intro :topic_id :published_at))
                    (pages-with-intro-cond topic-id)
                    page-index page-size))

(defun pages-with-published (page-index page-size)
  (fetch-pagination :pages
                    ((:id :title :topic_id :published))
                    nil
                    page-index page-size))
