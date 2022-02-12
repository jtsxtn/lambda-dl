#lang racket
(require "album-parser.rkt"
         "yt-search.rkt"
         "utils.rkt")

(provide MUSIC_DIR
         download-all-songs
         download-all-2
         download-all*)

(define MUSIC_DIR "/home/tom/Media/Musique/")


;; Yuge Mess, needs more flexibility
(define format-song
  (lambda (titre album artiste n)
    (string-append
     (string-append MUSIC_DIR
       (string-append artiste
         (string-append "--"
           (string-append
            (string-replace album "%27" "")
            "--"))))
     (string-append
      (string-append
       (number->string n)
       "--")
      (string-append
       (string-replace
        (string-replace titre " " "_") "/" "_")
       ".opus")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Yuge Mess, needs work
(define mon-read
  (lambda (title port portin porterr)
    (define temp (read port))
    (cond
      ((eof-object? temp) (close-input-port port) (close-input-port porterr) (close-output-port portin))
      ((or (list? temp) (number? temp) (string? temp)) (mon-read title port portin porterr))
      ((regexp-match #rx"[0-9][0-9][0-9]*\\.[0-9]\\%" (symbol->string temp)) (println (string-join (list title (car (regexp-match #rx"[0-9][0-9][0-9]*\\.[0-9]\\%" (symbol->string temp)))))) (mon-read title port portin porterr))
      (else (mon-read title port portin porterr)))))

(define mon-read-2
  (lambda (title port portin porterr)
    (define temp (read port))
    (cond
      ((eof-object? temp) (println (string-join (list title "fini"))) (close-input-port port) (close-input-port porterr) (close-output-port portin))
      (else (mon-read-2 title port portin porterr)))))

(define mon-read-3
  (lambda (title port portin porterr)
    (define temp (read port))
    (cond
      ((eof-object? temp) (close-input-port port) (close-input-port porterr) (close-output-port portin))
      (else (mon-read-3 title port portin porterr)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define download-song
  (lambda (lien titre album artiste n)
    (define new-titre (format-song titre album artiste n))
  (define-values (sp out in err)
    ;(subprocess #f #f #f "/bin/youtube-dl" "-i" "-c" "-x" "--audio-format" "opus" lien "-o" new-titre)
    (subprocess #f #f #f "/bin/yt-dlp" "-i" "-c" "-x" "--audio-format" "opus" lien "-o" new-titre))
    (thread (lambda () (mon-read-3 titre out in err)))))

(define download-all-songs
  (lambda (liens titres album artiste [n 1])
    (cond
      ;((null? liens) (printf "Starting download: ~a~n" album) '())
      ((null? liens) '())
      (else
       (cons
        (download-song (car liens) (car titres) album artiste n)
        (download-all-songs (cdr liens) (cdr titres) album artiste (add1 n)))))))

(define download-all
  (lambda (w album artiste)
    (define t (extract-tracklist w))
    (download-all-songs (get-track-links t artiste) t album artiste)))

(define download-all-2
  (lambda (tracklist album artiste)
     (download-all-songs (get-track-links tracklist artiste) tracklist album artiste)))

(define download-all*
  (lambda (lat albums a)
    (cond
      ((null? lat) '())
      (else
       (cons
        (download-all (load-sxml (car lat)) (car albums) a)
        (download-all* (cdr lat) (cdr albums) a))))))
