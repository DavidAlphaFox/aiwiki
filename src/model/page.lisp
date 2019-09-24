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
   :fetch-pagination)
  (:export
   :page-by-title
   :page-by-id
   :pages-with-intro
   :pages-only-title
   :total-pages
   :add-page
   ))

(in-package :aiwiki.model.page)

;;; Page model

(defun page-by-title (title)
  (fetch-one (db)
     (select :*
       (from :pages)
       (where (:= :title title)))))

(defun page-by-id (id)
  (fetch-one (db)
    (select :*
      (from :pages)
      (where (:= :id id)))))

(defun add-page (title intro content)
  (fetch-one (db)
    (insert-into :pages
      (set=
       :title title
       :intro intro
       :content content)
      (returning :id))))

(defun update-page (id title intro content publish)
  (execute-transaction (db)
    (update :pages
      (set= :title title)
      (set= :intro intro)
      (set= :content content)
      (set= :publish publish)
      (where (:= :id id)))))

(defun total-pages ()
  (fetch-one (db)
    (select ((:as (:count :id) :total))
      (from :pages))))


(defun pages-with-intro (page-index page-size)
  (fetch-pagination :pages '(:id :title :intro) page-index page-size))

(defun pages-only-title (page-index page-size)
  (fetch-pagination :pages '(:id :title) page-index page-size))
