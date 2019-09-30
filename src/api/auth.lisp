(in-package :cl-user)
(defpackage aiwiki.api.auth
  (:use
   :cl
   :caveman2
   :aiwiki.utils.view
   :aiwiki.utils.request
   :aiwiki.utils.auth
   :aiwiki.model.user)
  (:export
   :login))

(in-package :aiwiki.api.auth)


(defun login ()
  (let* ((username (fetch-parameter "username"))
         (password (fetch-parameter "password"))
         (user (find-user-by-username username)))
    (multiple-value-bind (password-correct username-found)
        (authenticate-user username password)
      (cond (password-correct (let ((token (login username)))
                                (render-json (list :token token))))
            (t (setf (status *response*) 401)))
)))
