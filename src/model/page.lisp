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
   :pages-with-brief
   :total-pages
   ))

(in-package :aiwiki.model.page)

;;; Page model

(defun page-by-title (title)
  (fetch-one (db)
     (select :*
       (from :pages)
       (where (:= :title title)))))

(defun pages-with-brief (pageIndex pageSize)
  (let ( (offset (* (- pageIndex 1) pageSize)))
    (with-connection (db)
      (retrieve-all
       (select (:id :title :brief)
               (from :pages)
               (offset offset)
               (limit pageSize))))))

(defun total-pages ()
  (select
   (:as (:count :id) :total)
   (from :pages)))
