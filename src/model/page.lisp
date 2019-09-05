;;;; model.lisp

(in-package :cl-user)

(defpackage aiwiki.model.page
  (:use :cl :sxql)
  (:import-from
   :aiwiki.base.db
   :db
   :fetch-one
   :fetch-all)
  (:export
   :page-by-title
   :page-by-id
   :pages-with-intro
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


(defun pages-with-intro (pageIndex pageSize)
  (let ( (pageOffset (* (- pageIndex 1) pageSize)))
    (fetch-all (db)
      (select (:id :title :intro)
        (from :pages)
        (offset pageOffset)
        (limit pageSize)))))

(defun total-pages ()
  (fetch-one (db)
    (select
        (:as (:count :id) :total)
      (from :pages))))
