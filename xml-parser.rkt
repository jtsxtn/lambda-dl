#lang racket
(require "utils.rkt")

(provide first-tag*
         start-with-tag*
         start-with-tag-countain*
         multstart-with-tag*
         start-with-tag-countain-rx*)

;; Returns the first x-expression starting with tag
(define first-tag*
  (lambda (w tg)
    (cond
      ((null? w) #f)
      ((atom? (car w))
       (cond
         ((equal? (car w) tg) w)
         (else (first-tag* (cdr w) tg))
         ))
      (else
       (or
        (first-tag* (car w) tg)
        (first-tag* (cdr w) tg)
        )))))



;; Returns a list of every x-expression starting with tag
(define start-with-tag*
  (lambda (xexp tg)
    (cond
      ((null? xexp) '())
      ((atom? (car xexp))
       (cond
         ((equal? (car xexp) tg) (list xexp))
         (else (start-with-tag* (cdr xexp) tg))))
      (else
       (cond
         ((null? (start-with-tag* (car xexp) tg)) (start-with-tag* (cdr xexp) tg))
         (else (append
             (start-with-tag* (car xexp) tg)
             (start-with-tag* (cdr xexp) tg))))))))


;; Returns a list of every x-expression starting with tag
;; and containing countain
(define start-with-tag-countain*
  (lambda (w tg ctn)
    (cond
      ((null? w) '())
      ((atom? (car w))
       (cond
         ((and
           (equal? (car w) tg)
           (member?* ctn (list w)))
          (list w))
         (else (start-with-tag-countain* (cdr w) tg ctn))))
      (else
       (cond
         ((null? (start-with-tag-countain* (car w) tg ctn)) (start-with-tag-countain* (cdr w) tg ctn))
         (else (append
             (start-with-tag-countain* (car w) tg ctn)
             (start-with-tag-countain* (cdr w) tg ctn))))))))



(define start-with-tag-countain-rx*
  (lambda (w tg [rx #px"track[0-9]+"])
    (cond
      ((null? w) '())
      ((atom? (car w))
       (cond
         ((and
           (equal? (car w) tg)
           (rx-member?* rx (list w)))
          (list w))
         (else (start-with-tag-countain-rx* (cdr w) tg rx))))
      (else
       (cond
         ((null? (start-with-tag-countain-rx* (car w) tg rx)) (start-with-tag-countain-rx* (cdr w) tg rx))
         (else (append
             (start-with-tag-countain-rx* (car w) tg rx)
             (start-with-tag-countain-rx* (cdr w) tg rx))))))))
;; Returns a list of every x-expression containing the
;; nested tag structure provided
(define multstart-with-tag*
  (lambda (w tg-list)
    (cond
      ((null? tg-list) w)
      (else (multstart-with-tag* (start-with-tag* w (car tg-list)) (cdr tg-list))))))
