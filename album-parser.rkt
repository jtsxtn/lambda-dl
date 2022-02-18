#lang racket
(require "xml-parser.rkt"
         "utils.rkt")

(provide extract-tracklist)

(define MIN_ALBUM_LENGTH 3)


(define extract-table
  (lambda (w)
    (map
     (lambda (lat) (first-tag* lat 'td))
     (start-with-tag-countain-rx* w 'tr))))

(define extract-tracklist-table
  (lambda (w)
    (define table (extract-table w))
    (map (lambda (s)
           (if
            (equal? (get-string s) "")
            (get-string (first-tag* s 'a))
            (get-string s)))
         table)))

(define extract-songlist
  (lambda (w)
    (start-with-tag-countain-rx*
     (start-with-tag* w 'ol)
     'li #px"[0-9]:[0-9][0-9]")))

(define extract-tracklist-songlist
  (lambda (w)
    (define songlist (extract-songlist w))
    (map (lambda (s) (or (get-string-2 s) (get-string (first-tag* s 'a)))) songlist)))

(define x-tracklist-special
  (lambda (w)
    (define temp (map (lambda (lat) (start-with-tag-countain-rx* lat 'td #px"\""))(start-with-tag-countain-rx* w 'tr #px"[0-9]+\n")))
    (extract-tracklist-special temp)))

(define extract-tracklist-special
  (lambda (temp)
    (cond
      ((null? temp) '())
      ((null? (car temp)) '())
      ((null? (caar temp)) '())
      ((string=? "" (get-string (caar temp)))
       (cons
        (get-string (first-tag* (caar temp) 'a))
        (extract-tracklist-special (cdr temp))
        ))
      (else
       (cons
        (get-string (caar temp))
        (extract-tracklist-special (cdr temp)))))))

(define tracklist?
  (lambda (lat)
    (and
     (not (null? lat))
     (< MIN_ALBUM_LENGTH (length lat)))))

(define extract-tracklist-raw
  (lambda (w)
    (cond
      ((tracklist? (x-tracklist-special w)) (x-tracklist-special w))
      (else (if
     (null? (extract-tracklist-table w))
     (extract-tracklist-songlist w)
     (extract-tracklist-table w))))))

(define clean-tracklist
  (lambda (lat)
   (remove-duplicates
    (remove*
     '("^")
     (filter string? lat)))))

(define extract-tracklist
  (lambda (w)
    (clean-tracklist (extract-tracklist-raw w))))

;; (define extract-tracklist
;;   (lambda (w album show-func)
;;     (define tracks (extract-tracklist-standard w))
;;     (pre-confirm-dl tracks album show-func)))


