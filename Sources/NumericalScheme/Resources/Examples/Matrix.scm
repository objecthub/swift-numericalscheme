;;; This is a small NumericalScheme program which defines two sample functions to
;;; create an empty matrix as well as a matrix given by a list of rows.

(import (numerical array))

(define (make-matrix nrow ncol)
  (make-f64array nrow ncol))

(define (rows->matrix rows)
  (let* ((ncol (length (car rows)))
         (matrix (make-matrix (length rows) ncol)))
    (let looprows ((rs rows)(i 0))
      (cond ((pair? rs)
               (let loopcols ((cs (car rs))(j 0))
                 (when (pair? cs)
                   (f64array-set! matrix (car cs) i j)
                   (loopcols (cdr cs) (+ j 1))))
               (looprows (cdr rs) (+ i 1)))
            (else matrix)))))

(define m (rows->matrix '((1 2 3 4 5) (6 7 8 9 10) (11 12 13 14 15))))
(display m)
(newline)

