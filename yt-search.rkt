#lang racket
(require "utils.rkt"
         "album-parser.rkt")

(provide get-track-links)

(define YT "https://www.youtube.com/watch?v=")
(define YT-SEARCH "https://www.youtube.com/results?search_query=")
(define RXYT #rx"\"videoId\":\"[A-Za-z0-9]+\"")
(define RXYT-MATCH #rx"\"videoId\":\"([A-Za-z0-9]+)\"")

(define build-yt-link 
  (lambda (lien)
    (string-append YT lien)))

(define build-yt-search
  (lambda (toune artiste)
     (string-append
      YT-SEARCH
      (string-replace toune " " "+")
      "+"
    (string-replace artiste " " "+")
    "+Album+Version")))


(define yt-regexp
  (lambda (y)
    (cond
      ((null? y) '())
      ((and
        (string? (car y))
        (regexp-match? RXYT (car y)))
       (append
        (remove-duplicates
         (regexp-match* RXYT-MATCH (car y) #:match-select cadr))
        (yt-regexp (cdr y))))
      (else (yt-regexp (cdr y))))))

(define get-yt-link
  (lambda (toune artiste)
    (define temp (yt-regexp (flatten (load-sxml (build-yt-search toune artiste)))))
    (cond
      ((null? temp) '())
      (else (build-yt-link (car temp)))
      )))

(define get-first-link
  (lambda (w)
    (get-yt-link (car (extract-tracklist w)) (get-artiste w))))

(define get-track-links
  (lambda (tracks artiste)
    (cond
      ((null? tracks) '())
      (else
       (cons
        (get-yt-link (car tracks) artiste)
        (get-track-links (cdr tracks) artiste)))
      )))
