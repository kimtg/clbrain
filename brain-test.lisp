;; accuracy: 0.9691
(load "brain.lisp")
(require "asdf")

(defun main ()
  ;; train
  (with-open-file (stream "mnist/mnist_train.csv")
    (loop for line = (read-line stream nil)
          for num-rows from 1
          while line
          do
          (format t "train ~a~%" num-rows)
          (let* ((split (uiop:split-string line :separator ","))
                    (input (coerce (mapcar #'parse-integer (cdr split)) 'vector))
                    (output (parse-integer (car split))))
            (brain:train input output)))
    (format t "train data loaded. rows: ~a~%" (length brain::*inputs*)))
  
  ;; test
  (with-open-file (stream "mnist/mnist_test.csv")
    (let ((num-correct 0))
      (loop for line = (read-line stream nil)
            for num-rows from 1
            while line
            do
            (format t "test ~a~%" num-rows)
            (let* ((split (uiop:split-string line :separator ","))
                   (input (coerce (mapcar #'parse-integer (cdr split)) 'vector))
                   (output (parse-integer (car split)))
                   ;; predict
                   (best (brain:guess input)))
              (when (= best output)
                (incf num-correct))
              (format t "predicted: ~a answer: ~a accuracy: ~a~%" best output (/ (coerce num-correct 'float) num-rows))
              )))))

(main)
