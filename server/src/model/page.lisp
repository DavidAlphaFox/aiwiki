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
   :pages-only-title
   :total-pages
   :add-page
   :update-page
   :publish-page
   ))

(in-package :aiwiki.model.page)

;;; Page model

(defmacro update-action (id fields)
  `(execute-transaction (db)
     (update :pages
       (set= ,@fields)
       (where (:= :id ,id)))))

(defmacro find-action (cond-statement)
  `(fetch-one (db)
     (select :*
       (from :pages)
       (where ,cond-statement))))

(defun page-by-title (title)
  (find-action (:= :title title)))

(defun page-by-id (id)
  (find-action (:= :id id)))

(defun add-page (title intro content)
  (fetch-one (db)
    (insert-into :pages
      (set=
       :title title
       :intro intro
       :content content)
      (returning :id))))

(defun update-page (id title intro content published)
  (update-action id (:title title :intro intro
                     :content content :published (to-db-boolean published))))

(defun publish-page (id published)
  (update-action id (:published (to-db-boolean published))))

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
                    (:id :title :intro)
                    (:= :published "true")
                    page-index page-size))

(defun pages-only-title (page-index page-size)
  (fetch-pagination :pages
                    (:id :title) nil
                    page-index page-size))
