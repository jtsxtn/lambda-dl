#lang racket
(require "utils.rkt")

(provide confirm-dl
         rename-albums
         pre-confirm-dl)

(define CTXALBUM "\033[36m\nRename albums:\n\n\033[34m")
(define CTXTRACK "\033[36m\nReview tracklists:\n\n\033[34m")

(define (get-option [prompt "-> "] #:default [default "Y"])
  (printf "~a" prompt)
  (let ([in (read-line)])
    (if (string=? in "")
        default
        in)))


(define (get-option-dl l)
  (get-option
   (string-append "Download " (name-from-wiki l) " [y/N/done/songs]? ")))

(define print-songs-link
  (lambda (lnk extract-func)
    (printf "~nSongs:~n")
    (map (lambda (a) (printf "~a~n" a)) (extract-func (load-sxml lnk)))
    (printf "~nPress Enter to continue")
    (read-line)))

(define confirm-dl
  (lambda (links show-func extract-func)
    (define temp-l (lambda (links) (if (null? links) '() (get-option-dl (car links)))))
    (define temp (temp-l links))
    (cond
      ((null? links) '())
      ((string=?  temp "y") (show-func)
       (cons
        (car links)
        (confirm-dl (cdr links) show-func extract-func)))
      ((string=? temp "songs")
       (print-songs-link (car links) extract-func)
       (show-func)
       (confirm-dl links show-func extract-func))
      (else
       (cond
         ((string=? temp "done") '())
         (else (show-func) (confirm-dl (cdr links) show-func extract-func)))))))

(define (get-option-name l)
  (get-option
   (string-append CTXALBUM "Rename " l " [y/N]? ")
   #:default "N"))

(define rename-albums
  (lambda (names show-func)
    (cond
      ((null? names) '())
      ((string=? (get-option-name (car names)) "N") (show-func)
       (cons (car names) (rename-albums (cdr names) show-func)))
      (else (show-func)
       (cons
        (get-new-name-album (car names) show-func)
        (rename-albums (cdr names) show-func)
        )))))

(define get-new-name-song
  (lambda (name show-func)
    (printf "~aNew name for ~a -> " CTXTRACK name)
    (let ([in (read-line)])
      (cond
        ((string=? in "") (show-func) (get-new-name-song name show-func))
        (else (show-func) in)))))

(define get-new-name-album
  (lambda (name show-func)
    (printf "~aNew name for ~a -> " CTXALBUM name)
    (let ([in (read-line)])
      (cond
        ((string=? in "") (show-func) (get-new-name-album name show-func))
        (else (show-func) in)))))

(define (get-option-dlre l)
  (get-option
   (string-append CTXTRACK "Download " l "? [Y/n/rename/all] ")))

(define confirm-dl-rename
  (lambda (names show-func)
    (define temp-l (lambda (names) (if (null? names) '() (get-option-dlre (car names)))))
    (define temp (temp-l names))
    (cond
      ((null? names) '())
      ((string=?  temp "Y")
       (show-func)
       (cons
        (car names)
        (confirm-dl-rename (cdr names) show-func)))
      ((string=? temp "rename")
       (show-func)
       (cons
        (get-new-name-song (car names) show-func)
        (confirm-dl-rename (cdr names) show-func)))
      ((string=? temp "all")
       (show-func)
       names)
      (else (show-func)(confirm-dl-rename (cdr names) show-func)))))

(define (get-option-pre-dl)
  (get-option "Download all songs as-is? [Y/n] "))

(define (get-option-re l)
  (get-option
   (string-append CTXTRACK "Review songs from " l "? [y/N] ") #:default "N"))

(define pre-confirm-dl
  (lambda (names album show-func)
    (define temp (get-option-re album))
    (cond
      ((string=? temp "y")
       (printf "~n~a songs:~n" album)
       (map (lambda (a) (printf "~a~n" a)) names)
       (cond
         ((string=? (get-option-pre-dl) "n") (show-func) (confirm-dl-rename names show-func))
         (else (show-func) names)))
      (else (show-func) names))))
