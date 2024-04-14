;; a general-purpose machine learning library
(defpackage :brain
  (:use :cl)
  (:export #:train #:guess))
(in-package :brain)

(defun square (x) (* x x))

(defun sum-square-error (xs ys)
  (when (/= (length xs) (length ys)) (return-from sum-square-error -1))
  (loop for x across xs
        for y across ys
        sum (abs (- x y))))

(defparameter *inputs* (make-array 0 :fill-pointer t :adjustable t))
(defparameter *outputs* (make-array 0 :fill-pointer t :adjustable t))

(defun train (input output)
  (vector-push-extend input *inputs*)
  (vector-push-extend output *outputs*))

(defun guess (input)
  (let ((best 0)
        (min-error -1))
    (loop for i from 0
          for d across *inputs*
          for error = (sum-square-error input d)
          when (or (< min-error 0) (< error min-error))
          do (setf min-error error
                   best (aref *outputs* i)))
    best
    ))