;;;; model.lisp

(in-package :cl-user)

(defpackage aiwiki.model.page
  (:use :cl :sxql)
  (:import-from
   :aiwiki.db
   :db
   :with-connection
   :with-transaction)
  (:import-from
   :datafly
   :execute
   :retrieve-all
   :retrieve-one)
  (:export
   :create-page-table
   :add-page
   :get-latest-page
   :get-latest-pages-titles
   :get-latest-pages-by-user
   :get-sorted-pages
   :count-pages
   :nth-page-revision))

(in-package :aiwiki.model.page)

;;; Page model

(defun create-page-table ()
  "Create page table if it doesn't exist yet."
  (with-connection (db)
    (execute
     (create-table (:pages :if-not-exists t)
         ((id :type 'serial :primary-key t)
          (title :type 'text :not-null t)
          (author-id :type 'integer :not-null t)
          (content :type 'text :not-null t)
          (date :type 'timestamp :not-null t)
          (latest :type 'boolean :not-null t)) ;; is this the latest version of the page
       (foreign-key '(:author-id) :references '(:user :id))))))

(defun add-page (title author content)
  "Add page to database. Mark it as \"latest: true\", mark previous \"latest: false\"."
  (with-transaction (db)
    (execute
     (update :pages
       (set= :latest "false")
       (where (:and
               (:= :title title)
               (:= :latest "true")))))
    (execute
     (insert-into :pages
       (set= :title title
             :author-id (getf (find-user author) :id)
             :content content
             :date (local-time:now)
             :latest "true")))))

(defun get-latest-page (title)
  "Get the latest version of a page by TITLE."
  (with-connection (db)
    (retrieve-one
     (select :*
       (from :pages)
       (where (:and (:= :title title)
                    (:= :latest "true")))))))

(defun get-latest-pages-titles ()
  "Get the titles of latest versions of pages"
  (with-connection (db)
    (retrieve-all
     (select :title
       (from :pages)
       (where (:= :latest "true"))
       (order-by (:desc :date))))))

(defun get-latest-pages-by-user (username)
  "Get the latest versions of all pages by USERNAME."
  (with-connection (db)
    (retrieve-all
     (select (:pages.id :title :username :content :date :latest)
       (fr3om :pages :user)
       (where (:and (:= :user.id :author-id)
                    (:= :user.username username)
                    (:= :latest "true")))))))

(defun get-sorted-pages (title)
  "Get all versions of a page by TITLE, sorted by it's timestamp in descending order, newest first."
  (with-connection (db)
    (retrieve-all
     (select :*
       (from :pages)
       (where (:= :title title))
       (order-by (:desc :date))))))

(defun count-pages (title)
  "Count the number of versions a page has."
  (with-connection (db)
    (getf (retrieve-one
           (select (:title (:count :id))
             (from :pages)
             (where (:= :title title))
             (group-by :title)))
          :count)))

(defun nth-page-revision (title n)
  "Get the nth version of a page, sorted by its DATE."
  (nth n (get-sorted-pages title)))
