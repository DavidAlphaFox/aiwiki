(in-package :cl-user)
(defpackage aiwiki.api.topic
  (:use
   :cl
   :caveman2
   :aiwiki.utils.view
   :aiwiki.utils.request
   :aiwiki.model.topic)
  (:export
   :index
   ))

(in-package :aiwiki.api.topic)

(defun index ()
  (let ((topics (all-topics-title)))
    (render-json topics)))
