#lang racket
(require "utils.rkt")

(provide get-disco-link)


(define GOOG "https://www.google.com/search?q=")
(define DISCO "+discography+wikipedia")
(define RXGOOG #px"http[s]*://en.wikipedia.org/wiki/[\\w\\-\\.]*_[dD]iscography")
(define RXGOOG-Match #px"(http[s]*://en.wikipedia.org/wiki/[\\w\\-\\.]*_[dD]iscography)")

(define build-goog-search
  (lambda (artiste)
    (string-append  GOOG (string-append (string-replace artiste " " "+") DISCO))))

(define goog-regexp
  (lambda (y)
    (cond
      ((null? y) '())
      ((and
        (string? (car y))
        (regexp-match? RXGOOG (car y)))
       (car
        (regexp-match* RXGOOG-Match (car y) #:match-select cadr)))
      (else (goog-regexp (cdr y))))))

(define get-disco-link
  (lambda (artiste)
    (goog-regexp (flatten (load-sxml (build-goog-search artiste))))))

