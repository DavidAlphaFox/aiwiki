(in-package :cl-user)

(defpackage aiwiki.model
  (:use
   :cl
   :aiwiki.model.user
   :aiwiki.model.page)
  (:export
   :create-tables
   :find-user
   :add-user
   :authenticate-user
   :add-page
   :get-latest-page
   :get-latest-pages-titles
   :get-latest-pages-by-user
   :get-sorted-pages
   :count-pages
   :nth-page-revision))
(in-package aiwiki.model)

(defun create-tables ()
  "Create all tables, if they don't exist already."
  (create-user-table)
  (create-page-table))

