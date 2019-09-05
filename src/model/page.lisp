;;;; model.lisp

(in-package :cl-user)

(defpackage aiwiki.model.page
  (:use :cl :sxql)
  (:import-from
   :aiwiki.db
   :db
   :fetch-one
   :fetch-all)
  (:export
   :page-by-title
   :pages-with-intro
   :total-pages
   ))

(in-package :aiwiki.model.page)

;;; Page model

(defun page-by-title (title)
  (fetch-one (db)
     (select :*
       (from :pages)
       (where (:= :title title)))))

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
