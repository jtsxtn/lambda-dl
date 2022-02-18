#lang racket
(require "xml-parser.rkt")
(provide get-albums-names
         get-albums-links)

(define WIKI "https://en.wikipedia.org")

(define get-albums-table
  (lambda (xexp)
    (define temp (remove-duplicates (multstart-with-tag* xexp '(tr th i a @ href))))
    (define temp2 (remove-duplicates (multstart-with-tag* xexp '(td i a href))))
    (if (null? temp)
        temp2
        temp)))

(define get-table-links
  (lambda (albums)
    (cond
      ((null? albums) '())
      (else
       (cons
        (string-append  WIKI (car (cdr (car albums))))
        (get-table-links (cdr albums)))))))

(define get-table-names
  (lambda (albums)
    (cond
      ((null? albums) '())
      (else
       (cons
        (string-replace (car albums) "https://en.wikipedia.org/wiki/" "")
        (get-table-names (cdr albums)))))))

(define get-albums-names
  (lambda (links)
    (get-table-names links)))

(define get-albums-links
  (lambda (w)
    (get-table-links (get-albums-table w))))
