#lang racket
(require "g-search.rkt"
         "album-parser.rkt"
         "disco-parser.rkt"
         "utils.rkt"
         "dwnld.rkt"
         "output.rkt"
         "interaction.rkt")

(define generate-tracklist
  (lambda (artist links names)
    (map
     (lambda (a b)
       (pre-confirm-dl
        (extract-tracklist a) b (lambda () (show artist names))))
     (map load-sxml links)
     names)))

(define main
  (lambda ()
    (show)
    (define artiste (get-artiste))
    (define flash (thread (lambda () (print-logo-cont))))
    (define discography (get-disco-link artiste))
    (define pre-links (get-albums-links (load-sxml discography)))
    (kill-thread flash)
    (show artiste)
    (define album-links
      (confirm-dl pre-links (lambda () (show artiste)) extract-tracklist))
    (show artiste (get-albums-names  album-links))
    (define album-names
      (rename-albums
       (get-albums-names  album-links)
       (lambda () (show artiste (get-albums-names  album-links)))))
    (show artiste album-names)
    (define tracklists (generate-tracklist artiste album-links album-names))
    (cond
      ((null? discography) (printf "Could not extract discography from Wikipedia~n"))
      ((null? album-links) (printf "Could not extract albums from Wikipedia~n"))
      (else
       (define dots (thread (lambda ()
                              (print-dots-cont
                               (lambda ()(show artiste album-names))))))
       (print-progress (map (lambda (t a) (download-all t a artiste)) tracklists album-names))
       (kill-thread dots)))))


(main)
