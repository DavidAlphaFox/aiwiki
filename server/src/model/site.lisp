(in-package :cl-user)

(defpackage aiwiki.model.site
  (:use :cl :sxql)
  (:import-from
   :aiwiki.base.db
   :db
   :execute-transaction
   :fetch-one
   :fetch-all)
  (:export
   :fetch-site
   :fetch-utm
   :site-info
   :update-site-info
   ))

(in-package :aiwiki.model.site)

(defun site-info ()
  (fetch-one (db)
    (select :*
      (from :site))))

(defun update-site-info (id brand intro keywords header footer
                         utm-source utm-campaign utm-medium)
  (execute-transaction (db)
    (update :site
      (set= :brand brand :intro intro :keywords keywords
            :header header :footer footer
            :utm_source utm-source :utm_campaign utm-campaign
            :utm_medium utm-medium)
      (where (:= :id id)))))

(defun fetch-site ()
  (fetch-one (db)
             (select (:brand :intro :keywords :header :footer)
                     (from :site))))
(defun fetch-utm ()
  (fetch-one (db)
             (select (:utm_source :utm_campaign :utm_medium)
                     (from :site))))
