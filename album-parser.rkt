#lang racket
(require "xml-parser.rkt"
         "utils.rkt")

(provide extract-tracklist
         extract-tracklist-review
         confirm-dl-rename
         get-artiste)


(define (get-option [prompt "-> "] #:default [default "Y"])
  (printf "\033[s~a" prompt)
  (let ([in (read-line)])
    (if (string=? in "")
        default
        in)))

(define (get-option-2 [prompt "-> "] #:default [default "Y"])
  (printf "~a" prompt)
  (let ([in (read-line)])
    (if (string=? in "")
        default
        in)))

(define clean-up
  (lambda ()
    (printf "\033[u\033[0J")))

(define (get-option-name l)
  (get-option
   (string-append "Rename " l " [y/N]? ")
   #:default "N"))

(define (get-option-dl l)
  (get-option
   (string-append "Download " l "? [Y/n/all] ")))

(define (get-option-pre-dl)
  (get-option-2 "Download all songs as-is? [Y/n] "))

(define (get-option-re l)
  (get-option
   (string-append "Review songs from " l "? [y/N] ") #:default "N"))

(define (get-option-dlre l)
  (get-option
   (string-append "Download " l "? [Y/n/rename/all] ")))

(define get-new-name
  (lambda (name)
    (printf "\033[sNew name for ~a -> " name)
    (let ([in (read-line)])
      (cond
        ((string=? in "") (clean-up) (get-new-name name))
        (else (clean-up) in)))))

(define confirm-dl
  (lambda (names)
    (define temp-l (lambda (names) (if (null? names) '() (get-option-dl (car names)))))
    (define temp (temp-l names))
    (cond
      ((null? names) '())
      ((string=?  temp "Y")
       (cons
        (car names)
        (confirm-dl (cdr names))))
      (else
       (if (string=? temp "all")
           names
           (confirm-dl (cdr names)))))))

(define confirm-dl-rename
  (lambda (names)
    (define temp-l (lambda (names) (if (null? names) '() (get-option-dlre (car names)))))
    (define temp (temp-l names))
    (cond
      ((null? names) '())
      ((string=?  temp "Y") (clean-up)
       (cons
        (car names)
        (confirm-dl-rename (cdr names))))
      ((string=? temp "rename") (clean-up)
                                (cons
                                 (get-new-name (car names))
                                 (confirm-dl-rename (cdr names))))
      ((string=? temp "all") (clean-up) names)
      (else (clean-up)(confirm-dl-rename (cdr names))))))

(define pre-confirm-dl
  (lambda (names album show-func)
    (define temp (get-option-re album))
    (cond
      ((string=? temp "y")
       (printf "~n~a songs:~n" album)
       (map (lambda (a) (printf "~a~n" a)) names)
       (cond
         ((string=? (get-option-pre-dl) "n") show-func (confirm-dl-rename names))
         (else show-func names)))
      (else show-func names))))

;; Gets the artist's name from album page
(define get-artiste
  (lambda (w)
    (car (cdr (car (multstart-with-tag* w '(table div title)))))))

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
    (start-with-tag-countain-rx* (start-with-tag* w 'ol) 'li #px"[0-9]:[0-9][0-9]")))

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


(define remove-non-strings
  (lambda (lat)
    (cond
      ((null? lat) '())
      ((string? (car lat))
       (cons
        (car lat)
        (remove-non-strings (cdr lat))))
      (else (remove-non-strings (cdr lat))))))

(define extract-tracklist
  (lambda (w album show-func)
    (cond
      ((not (null? (x-tracklist-special w)))
       (pre-confirm-dl (remove-duplicates (remove* '("^")(x-tracklist-special w))) album show-func))
      (else (if
     (null? (extract-tracklist-table w))
     (pre-confirm-dl (remove-non-strings (remove-duplicates (remove* '("^") (extract-tracklist-songlist w)))) album show-func)
     (pre-confirm-dl (remove-non-strings (remove-duplicates (remove* '("^") (extract-tracklist-table w)))) album show-func))))))

(define extract-tracklist-review
  (lambda (w)
    (cond
      ((not (null? (x-tracklist-special w)))
       (remove-duplicates (remove* '("^")(x-tracklist-special w))))
      (else (if (null? (extract-tracklist-table w))
             (remove-non-strings (remove-duplicates (remove* '("^") (extract-tracklist-songlist w))))
             (remove-non-strings (remove-duplicates (remove* '("^") (extract-tracklist-table w))))
             )))))


