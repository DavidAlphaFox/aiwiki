(in-package :cl-user)
(defpackage aiwiki.sqids
  (:use
    :cl))


(in-package :aiwiki.sqids)

(defparameter alphabet "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

(defun shuffle (alphabet)
  (let* ((l (length alphabet))
          (o (string-to-octets alphabet))
          (n (- l 1)))
    (loop for i from 0
      for j downfrom n to 1
      do
      (let* ((ci (aref o i))
             (cj (aref o j))
             (r (rem (+ ci cj (* i j)) l)))
        (let ((cr (aref o r)))
          (setf (aref o r ) ci)
          (setf (aref o i) cr)
          )))
    (octets-to-string o)))
