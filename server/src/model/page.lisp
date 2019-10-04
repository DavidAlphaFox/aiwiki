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

(defun add-page (title intro content)
  (fetch-one (db)
    (insert-into :pages
      (set=
       :title title
       :intro intro
       :content content)
      (returning :id))))

(defun update-page (id title intro content published)
  (execute-transaction (db)
    (let ((r (find-action (:published) (:= :id id))))
      (if (and (not (access:access r :published)) published)
          (update-action id (:title title :intro intro
                             :content content :published (to-db-boolean published)))
          (update-action id (:title title :intro intro :published_at (:raw "now() AT TIME ZONE 'UTC'")
                             :content content :published (to-db-boolean published)))))))

(defun publish-page (id published)
  (execute-transaction (db)
    (let ((r (find-action (:published) (:= :id id))))
      (if (and (access:access r :published) published)
          (update-action id (:published (to-db-boolean published)))
          (update-action id (:published (to-db-boolean published)
                             :published_at (:raw "now() AT TIME ZONE 'UTC'")))))))

(defun total-pages (&key published)
  (fetch-one (db)
    (if published
        (select ((:as (:count :id) :total))
          (from :pages)
          (where (:= :published (to-db-boolean published))))
        (select ((:as (:count :id) :total))
          (from :pages)))))


(defun pages-with-intro (page-index page-size)
  (fetch-pagination :pages
                    ((:id :title :intro :published_at))
                    (:= :published "true")
                    page-index page-size))

(defun pages-with-published (page-index page-size)
  (fetch-pagination :pages
                    ((:id :title :published))
                    nil
                    page-index page-size))
