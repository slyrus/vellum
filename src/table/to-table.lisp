(in-package #:cl-df.table)


(cl-ds.alg.meta:define-aggregation-function
    to-table to-table-function

  (:range &key key class header-class columns)

  (:range &key
          (key #'identity)
          (class 'standard-table)
          (header-class 'cl-df.header:standard-header)
          columns)

  (%iterator %class %columns %column-count %header)

  ((&key class header-class columns &allow-other-keys)
   (setf %header (apply #'cl-df.header:make-header
                        header-class columns)
         %class class
         %column-count (cl-data-frames.header:column-count %header)
         %columns (make-array %column-count))
   (iterate
     (for i from 0 below %column-count)
     (setf (aref %columns i)
           (cl-df.column:make-sparse-material-column
            :element-type (cl-df.header:column-type %header i))))
   (setf %iterator (cl-df.column:make-iterator %columns)))

  ((row)
   (iterate
     (for i from 0 below %column-count)
     (setf (cl-df.column:iterator-at %iterator i)
           (cl-df.header:row-at %header row i)))
   (cl-df.column:move-iterator %iterator 1))

  ((cl-df.column:finish-iterator %iterator)
   (make %class
         :header %header
         :columns %columns)))
