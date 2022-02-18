#lang racket
(require net/url
         html-parsing)

(provide atom?
         load-sxml
         member?*
         rx-member?*
         get-string
         get-string-2
         name-from-wiki
         get-artiste)



;; Sweet sweet Little Schemer
(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))


;; Load html from url as an s-expression (x-expression)
(define load-sxml
  (lambda (string-lien)
    (cond
      ((null? string-lien) '())
      (else (html->xexp
     (get-pure-port
      (string->url string-lien)))))))


;; True if a (s-expression) is somewhere in lat (s-expression)
(define member?*
  (lambda (a lat)
    (cond
      ((null? lat) #f)
      ((equal? (car lat) a) #t)
      (else
       (cond
         ((atom? (car lat)) (member?* a (cdr lat)))
         (else
          (or
           (member?* a (car lat))
           (member?* a (cdr lat)))))))))

;; True if a regexp is somewhere in lat (s-expression)
(define rx-member?*
  (lambda (rx lat)
    (cond
      ((null? lat) #f)
      ((atom? (car lat))
       (cond
         ((and (string? (car lat)) (regexp-match? rx (car lat))))
         (else (rx-member?* rx (cdr lat)))))
        (else
          (or
           (rx-member?* rx (car lat))
           (rx-member?* rx (cdr lat)))))))

;; Returns the first string not in a list string and
;; removes "\"; usefull for getting plain text
(define get-string
  (lambda (lat)
    (cond
      ((not lat) #f)
      ((null? lat) #f)
      ((string? (car lat)) (string-trim (string-replace (car lat) "\"" "")))
      (else (get-string (cdr lat)))
      )))

;; Returns the first string between \" 
;; usefull for getting text when there is link
(define get-string-2
  (lambda (lat)
    (cond
      ((not lat) #f)
      ((null? lat) #f)
      ((and
        (string? (car lat))
        (regexp-match? #px"\".*\"" (car lat))
        (not ; Few cases, but necessary for weird formats
         (string-contains?
          (cadr (regexp-match #px"\"(.*)\"" (car lat)))  "\"")))
       (string-trim (cadr (regexp-match #px"\"(.*)\"" (car lat)))))
      (else (get-string-2 (cdr lat))))))

(define name-from-wiki
  (lambda (l)
    (string-replace l "https://en.wikipedia.org/wiki/" "")))

(define get-artiste
  (lambda ()
    (printf "Name of band or artist -> ")
    (let ([in (read-line)])
      (cond
        ((string=? in "") (get-artiste))
        (else in)))))
