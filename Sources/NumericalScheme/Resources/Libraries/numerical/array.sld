;;; NUMERICAL ARRAY
;;;
;;; Simple sample library which implements multi-dimensional arrays using a vector.
;;;
;;; Author: Matthias Zenger
;;; Copyright © 2019 Matthias Zenger. All rights reserved.
;;;
;;; Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
;;; except in compliance with the License. You may obtain a copy of the License at
;;;
;;;   http://www.apache.org/licenses/LICENSE-2.0
;;;
;;; Unless required by applicable law or agreed to in writing, software distributed under the
;;; License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
;;; either express or implied. See the License for the specific language governing permissions
;;; and limitations under the License.

(define-library (numerical array)

  (export make-f64array
          f64array?
          f64array-ref
          f64array-set!)

  (import (lispkit base)
          (numerical vector))

  (begin

    (define-values (new-f64array f64array? f64array-unwrap make-f64array-subtype)
                   (make-type 'f64array))

    (define (make-f64array . dims)
      (new-f64array (cons (make-f64vector (apply * dims)) dims)))

    (define (index dims indx)
      (if (pair? dims)
          (fx+ (car indx) (fx* (car dims) (index (cdr dims) (cdr indx))))
          0))

    (define (f64array-ref a . indx)
      (let ((v (f64array-unwrap a)))
        (f64vector-ref (car v) (index (cdr v) indx))))

    (define (f64array-set! a val . indx)
      (let ((v (f64array-unwrap a)))
        (f64vector-set! (car v) (index (cdr v) indx) val)))
  )
)
