(in-package :cl-user)

(defpackage aiwiki.model.site
  (:use :cl :sxql)
  (:import-from
   :aiwiki.base.db
   :db
   :fetch-one
   :fetch-all)
  (:export
   :fetch-site
   :fetch-utm
   ))

(in-package :aiwiki.model.site)

(defun fetch-site ()
  (fetch-one (db)
             (select (:brand :intro :keywords :header :footer)
                     (from :site))))
(defun fetch-utm ()
  (fetch-one (db)
             (select (:utm_source :utm_campaign :utm_medium)
                     (from :site))))
