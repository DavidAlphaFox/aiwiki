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
   :login
   :update-password
   :verify-token))

(in-package :aiwiki.api.auth)


(defun login ()
  (let* ((username (fetch-parameter "username"))
         (password (fetch-parameter "password"))
         (user (find-user-by-username username)))
    (multiple-value-bind (password-correct username-found)
        (authenticate-user user password)
      (cond (password-correct (let ((token (gen-token username)))
                                (render-json (list :token token))))
            (t (setf (response-status *response*) "401"))))))
(defun update-password ()
  (let* ((old-password (fetch-parameter "oldPassword"))
         (new-password (fetch-parameter "newPassword"))
         (username (authenticated-user))
         (user (find-user-by-username username)))
    (multiple-value-bind (password-correct username-found)
        (authenticate-user user old-password)
      (cond (password-correct (let ((token (gen-token username)))
                                (render-json (list :token token))))
            (t (setf (response-status *response*) "403"))))))

(defun verify-token ()
  (multiple-value-bind (verified username)
      (verified-token)
    (cond (verified (let ((token (gen-token username)))
                      (render-json (list :token token))))
          (username (let ((token (gen-token username)))
                      (render-json (list :token token))))
          (t (render-json (list :token nil))))))
