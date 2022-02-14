#! /usr/bin/racket
#lang racket
(require "g-search.rkt"
         "album-parser.rkt"
         "disco-parser.rkt"
         "utils.rkt"
         "dwnld.rkt"
         "output.rkt")

(define main
  (lambda ()
    (show)
    (define artiste (get-artiste))
    (define flash (thread (lambda () (print-logo-cont))))
    (define discography (get-disco-link artiste))
    (define pre-links (get-albums-links (load-sxml discography)))
    (kill-thread flash)
    (show artiste)
    (define album-links (confirm-dl pre-links (lambda () (show artiste))))
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
    ;; (printf "\033[36m")
    ;; (printf "~nReview tracklists:~n~n")
    ;; (printf "\033[34m")
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
           (printf "~n~n")
           (define dots (thread (lambda () (print-dots-cont))))
           (print-progress (map (lambda (t a) (download-all-2 t a artiste)) tracklists album-names))
           (kill-thread dots)))))


(main)
