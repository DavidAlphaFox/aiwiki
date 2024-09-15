(in-package :cl-user)
(defpackage aiwiki.sqids
  (:use
    :cl))


(in-package :aiwiki.sqids)

(define-condition update-immutable-slot (error)
  ())
(define-condition max-regenerate-id (error)
  ())

(defclass sqids ()
  ((alphabet
     :initarg :alphabet
     :initform "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
     :accessor alphabet)))

(defmethod (setf alphabet) (nval (instance sqids))
  (error
    (make-condition 'update-immutable-slot)))


;; alphabet 需要是一个list
(defun shuffle (alphabet)
    (loop
      with l = (length alphabet)
      and n = (- (length alphabet) 1)
      and o = alphabet
      for i from 0
      for j downfrom n to 1
      do
      (let* ((ci (aref o i))
             (cj (aref o j))
             (r (rem (+ (char-code ci)
                       (char-code cj)
                       (* i j)) l)))
        (let ((cr (aref o r)))
          (setf (aref o r) ci)
          (setf (aref o i) cr)))
      finally (return o)))
;; (shuffle "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
;;"fwjBhEY2uczNPDiloxmvISCrytaJO4d71T0W3qnMZbXVHg6eR8sAQ5KkpLUGF9"

(defun to-id (num alphabet)
  (coerce
    (reverse
      (loop with l = (length alphabet)
        for x = num
        then (multiple-value-bind (q _) (floor x l) q)
        while (> x 0)
        nconc (list (aref alphabet (rem x l))))) 'string))

;; (to-id 111 "fwjBhEY2uczNPDiloxmvISCrytaJO4d71T0W3qnMZbXVHg6eR8sAQ5KkpLUGF9")
;; w8

(defun calculate-offset (numbers incr alphabet)
  (let ((al (length alphabet))
         (nl (length numbers)))
    (loop
      with offset = nl
      for i from 0 to (- nl 1)
      do (let* ((num (nth i numbers))
                 (pos (rem num al))
                 (code (char-code (aref alphabet pos))))
           (setq offset
             (+ offset code i)))
      finally (return (rem (+ incr offset) al))
    )))

(defun encode (numbers incr alphabet)
  (when (> incr (length alphabet))
    (error (make-condition 'max-regenerate-id)))
  (let* ((offset (calculate-offset numbers incr alphabet))
          (hl (subseq alphabet offset))
          (tl (subseq alphabet 0 offset))
          (a (concatenate 'string hl tl))
          (prefix (aref a 0))
          (nalphabet (reverse a)))
    (loop
      with nl = (length numbers)
      and ids = (list prefix)
      and nlast = (- (length numbers) 1)
      for i from 0 to nlast
      do (let ((separator (aref nalphabet 0))
               (nalphabet-with-separator (subseq nalphabet 1)))
           (if (< i nlast)
             (progn
               (setq ids (nconc ids
                           (coerce (to-id (nth i numbers) nalphabet-with-separator) 'list)
                           (list separator)))
               (setq nalphabet (shuffle nalphabet)))
             (setq ids
               (nconc ids (coerce (to-id (nth i numbers) nalphabet-with-separator) 'list)))))
      finally (return ids))))
