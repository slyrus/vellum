(in-package #:cl-df.table)


(defun selection (start end &rest more-start-ends)
  (declare (type non-negative-fixnum start end))
  (let* ((arguments (~> `(,start ,end ,@more-start-ends) (batches 2)))
         (starts (map '(vector fixnum) #'first arguments))
         (ends (map '(vector fixnum) #'second arguments)))
    (unless (every (compose (curry #'eql 2) #'length) arguments)
      (error 'cl-ds:argument-error
             :argument 'more-start-ends
             :format-control "Odd number of arguments passed to the selection (~a)."
             :format-arguments (length more-start-ends)))
    (make 'selection :starts starts :ends ends)))


(declaim (inline transform-control))
(defun transform-control ()
  (when (null *transform-control*)
    (error 'no-transformation))
  *transform-control*)


(defun finish-transformation ()
  (funcall (transform-control) :finish))


(defun nullify ()
  (funcall (transform-control) :nullify))