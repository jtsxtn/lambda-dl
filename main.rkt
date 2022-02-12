#! /usr/bin/racket
#lang racket
(require "g-search.rkt"
         "album-parser.rkt"
         "disco-parser.rkt"
         "utils.rkt"
         "dwnld.rkt"
         "output.rkt")


(define logo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣴⣦⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣠⣾⣿⣿⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣶⡀⠀⠀⠀⠀
⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀ ⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣦⠀⠀⠀
⠀⠀⣼⣿⣿⠋⠀⠀⠀⠀⠀  ⢻⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀
⠀⢸⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⡇⠀
⠀⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀
⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡟⢹⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⣹⣿⣿⠀
⠀⣿⣿⣷⠀⠀⠀⠀⠀⠀⣰⣿⣿⠏⠀⠀⢻⣿⣿⡄⠀⠀⠀⠀⠀⠀⣿⣿⡿⠀
⠀⢸⣿⣿⡆⠀⠀⠀⠀⣴⣿⡿⠃⠀⠀⠀⠈⢿⣿⣷   ⠀⠀⣰⣿⣿⠇⠀
⠀⠀⢻⣿⣿⣄⠀⠀    ⠀⠀⠀⠀⠀      ⠀⣰⣿⣿⡟⠀⠀
⠀⠀⠀⠻⣿⣿⣧ ⠀ lambda-dl  ⠀⣠⣾⣿⣿⠏⠀⠀⠀
⠀⠀⠀⠀⠈⠻⣿⣿⣷⣤⣄       ⢀⣠⣴⣾⣿⣿⠟⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠛⠿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀")

(define logo2 "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣴⣦⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⠿⠿⠿⠿⣿⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣠⣾⣿⣿⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣶⡀⠀⠀⠀⠀
⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀ ⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣦⠀⠀⠀
⠀⠀⣼⣿⣿⠋⠀⠀⠀⠀⠀  ⢻⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀
⠀⢸⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⡇⠀
⠀⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀
⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡟⢹⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⣹⣿⣿⠀
⠀⣿⣿⣷⠀⠀⠀⠀⠀⠀⣰⣿⣿⠏⠀⠀⢻⣿⣿⡄⠀⠀⠀⠀⠀⠀⣿⣿⡿⠀
⠀⢸⣿⣿⡆⠀⠀⠀⠀⣴⣿⡿⠃⠀⠀⠀⠈⢿⣿⣷   ⠀⠀⣰⣿⣿⠇⠀
⠀⠀⢻⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀          ⠀⣰⣿⣿⡟⠀⠀
⠀⠀⠀⠻⣿⣿⣧  Please Wait ⠀⣠⣾⣿⣿⠏⠀⠀⠀
⠀⠀⠀⠀⠈⠻⣿⣿⣷⣤⣄       ⢀⣠⣴⣾⣿⣿⠟⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠛⠿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀")


(define name-from-wiki
  (lambda (l)
    (string-replace l "https://en.wikipedia.org/wiki/" "")))

(define (get-option-old [prompt "-> "] #:default [default "Y"])
  (printf prompt)
  (let ([in (read-line)])
    (if (string=? in "")
        default
        in)))

(define (get-option [prompt "-> "] #:default [default "Y"])
  (printf "\033[s~a" prompt)
  (let ([in (read-line)])
    (if (string=? in "")
        default
        in)))

(define clean-up
  (lambda ()
    (printf "\033[u\033[0J")))

(define (get-option-dl l)
  (get-option
   (string-append "Download " (name-from-wiki l) " [y/N/done]? ")))

(define (get-option-dl-2 l)
  (get-option
   (string-append "Download " (name-from-wiki l) " [y/N/done/songs]? ")))

(define (get-option-name l)
  (get-option
   (string-append "Rename " l " [y/N]? ")
   #:default "N"))

(define get-artiste
  (lambda ()
    (printf "Name of band or artist -> ")
    (let ([in (read-line)])
        (if (string=? in "")
            (get-artiste)
            in))))

(define get-new-name-old
  (lambda ()
    (printf "New name -> ")
    (let ([in (read-line)])
        (if (string=? in "")
            (get-new-name)
            in))))

(define get-new-name
  (lambda (name)
    (printf "\033[sNew name for ~a -> " name)
    (let ([in (read-line)])
      (cond
        ((string=? in "") (clean-up) (get-new-name name))
        (else (clean-up) in)))))

(define confirm-dl
  (lambda (links)
    (define temp-l (lambda (links) (if (null? links) '() (get-option-dl (car links)))))
    (define temp (temp-l links))
    (cond
      ((null? links) '())
      ((string=?  temp "y")
       (cons
        (car links)
        (confirm-dl (cdr links))))
      (else
       (if (string=? temp "done")
           '()
           (confirm-dl (cdr links)))))))

(define confirm-dl-2
  (lambda (links)
    (define temp-l (lambda (links) (if (null? links) '() (get-option-dl-2 (car links)))))
    (define temp (temp-l links))
    (cond
      ((null? links) '())
      ((string=?  temp "y")
       (cons
        (car links)
        (confirm-dl-2 (cdr links))))
      ((string=? temp "songs")
       (printf "~nSongs:~n")
       (map (lambda (lat) (printf "~a\n" lat))(extract-tracklist-review (load-sxml (car links))))
       (printf "~n")
       (confirm-dl-2 links))
      (else
       (if (string=? temp "done")
           '()
           (confirm-dl-2 (cdr links)))))))

(define confirm-dl-3
  (lambda (links)
    (define temp-l (lambda (links) (if (null? links) '() (get-option-dl-2 (car links)))))
    (define temp (temp-l links))
    (cond
      ((null? links) '())
      ((string=?  temp "y") (clean-up)
       (cons
        (car links)
        (confirm-dl-3 (cdr links))))
      ((string=? temp "songs")
       (printf "~nSongs:~n")
       (map (lambda (a) (printf "~a~n" a)) (extract-tracklist-review (load-sxml (car links))))
       (printf "~nPress Enter to continue")
       (read-line)
       (clean-up)
       (confirm-dl-3 links))
      (else
       (cond
         ((string=? temp "done") '())
         (else (clean-up) (confirm-dl-3 (cdr links))))))))

(define confirm-dl-4
  (lambda (links show-func)
    (define temp-l (lambda (links) (if (null? links) '() (get-option-dl-2 (car links)))))
    (define temp (temp-l links))
    (cond
      ((null? links) '())
      ((string=?  temp "y") (show-func)
       (cons
        (car links)
        (confirm-dl-4 (cdr links) show-func)))
      ((string=? temp "songs")
       (printf "~nSongs:~n")
       (map (lambda (a) (printf "~a~n" a)) (extract-tracklist-review (load-sxml (car links))))
       (printf "~nPress Enter to continue")
       (read-line)
       (show-func)
       (confirm-dl-4 links show-func))
      (else
       (cond
         ((string=? temp "done") '())
         (else (show-func) (confirm-dl-4 (cdr links) show-func)))))))

(define rename-albums
  (lambda (names)
    (cond
      ((null? names) '())
      ((string=? (get-option-name (car names)) "N") (clean-up)
       (cons (car names) (rename-albums (cdr names))))
      (else (clean-up)
       (cons
        (get-new-name (car names))
        (rename-albums (cdr names))
        )))))

(define print-logo
  (lambda ()
    (printf "~a~n~n" logo)))

(define print-logo-2
  (lambda ()
    (printf "~a~n~n" logo2)))

(define print-logo-cont
  (lambda ([n 0])
    (printf "\033[2J\033[H")
    (printf "\033[38;5;~am" (+ 190 (modulo n 30)))
    (print-logo-2)
    (sleep 0.5)
    (print-logo-cont (add1 n))))



(define main
  (lambda ()
    (show)
    (define artiste (get-artiste))
    (define flash (thread (lambda () (print-logo-cont))))
    (define discography (get-disco-link artiste))
    (define pre-links (get-albums-links (load-sxml discography)))
    (kill-thread flash)
    (show artiste)
    (define album-links (confirm-dl-4 pre-links (lambda () (show artiste))))
    (show artiste (get-albums-names  album-links))
    (printf "\033[2J\033[H")
    (printf "\033[33m")
    (print-logo)
    (printf "Artist: ~a~n~n" artiste)
    (printf "Albums: ~n")
    (map (lambda (lat) (printf "~a~n" lat)) (get-albums-names  album-links))
    (printf "\033[36m")
    (printf "~nRename albums:~n~n")    
    (printf "\033[34m")    
    (define album-names (rename-albums (get-albums-names  album-links)))
    (show artiste album-names)
    (printf "\033[36m")
    (printf "~nReview tracklists:~n~n")
    (printf "\033[34m")
    (define tracklists (map (lambda (a b) (extract-tracklist a b (lambda () (show artiste album-names)))) (map load-sxml album-links) album-names))
    (cond
      ((null? discography) (printf "Could not extract discography from Wikipedia~n"))
      ((null? album-links) (printf "Could not extract albums from Wikipedia~n"))
      (else
           (printf "\033[2J\033[H")
           (printf "\033[33m")
           (print-logo)
           (printf "Artiste: ~a~n~n" artiste)
           (printf "Albums: ~n")
           (map (lambda (lat) (printf "~a~n" lat)) album-names)
           (printf "\033[36m")
           ;(printf "~nFetching ~a album(s) ~n" (length album-names))
           (printf "~n~n")
           (define dots (thread (lambda () (print-dots-cont))))
           (print-progress (map (lambda (t a) (download-all-2 t a artiste)) tracklists album-names))
           (kill-thread dots)))))


(main)
