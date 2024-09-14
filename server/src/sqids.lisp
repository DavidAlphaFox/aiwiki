(in-package :cl-user)
(defpackage aiwiki.sqids
  (:use
    :cl))


(in-package :aiwiki.sqids)

(define-condition update-immutable-slot (error)
  ())

(defclass sqids ()
  ((alphabet
     :initarg :alphabet
     :initform "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
     :accessor alphabet)))

(defmethod (setf alphabet) (nval (instance sqids))
  (error
    (make-condition 'update-immutable-slot)))

(defun string-to-chars (str)
        (map 'list
          #'char-code
          (coerce str 'list)))
(defun chars-to-string (chars)
        (coerce
          (map 'list
            #'code-char
            chars) 'string))
;; alphabet 需要是一个list
(defun shuffle (alphabet)
    (loop
      with l = (length alphabet)
      and n = (- (length alphabet) 1)
      and o = alphabet
      for i from 0
      for j downfrom n to 1
      do
      (let* ((ci (nth i o))
             (cj (nth j o))
             (r (rem (+ ci cj (* i j)) l)))
        (let ((cr (nth r o)))
          (setf (nth r o) ci)
          (setf (nth i o) cr)))
      finally (return o)))
;; (chars-to-string (shuffle (string-to-chars "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")))
;;"fwjBhEY2uczNPDiloxmvISCrytaJO4d71T0W3qnMZbXVHg6eR8sAQ5KkpLUGF9"

(defun to-id (num alphabet)
  (reverse
    (loop with l = (length alphabet)
      for x = num
      then (multiple-value-bind (q _) (floor x l) q)
      while (> x 0)
      nconc (list (nth (rem x l) alphabet)))))

;; (chars-to-string (to-id 111 (string-to-chars "fwjBhEY2uczNPDiloxmvISCrytaJO4d71T0W3qnMZbXVHg6eR8sAQ5KkpLUGF9")))
;; w8
