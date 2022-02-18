#lang racket
(require "yt-search.rkt"
         "utils.rkt")

(provide MUSIC_DIR
         download-all-songs
         download-all)

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
      (else (mon-read title port portin porterr)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define download-song
  (lambda (lien titre album artiste n)
    (define new-titre (format-song titre album artiste n))
  (define-values (sp out in err)
    ;(subprocess #f #f #f "/bin/youtube-dl" "-i" "-c" "-x" "--audio-format" "opus" lien "-o" new-titre)
    (subprocess #f #f #f "/bin/yt-dlp" "-i" "-c" "-x" "--audio-format" "opus" lien "-o" new-titre))
    (thread (lambda () (mon-read titre out in err)))))

(define download-all-songs
  (lambda (liens titres album artiste [n 1])
    (cond
      ((null? liens) '())
      (else
       (cons
        (download-song (car liens) (car titres) album artiste n)
        (download-all-songs (cdr liens) (cdr titres) album artiste (add1 n)))))))

(define download-all
  (lambda (tracklist album artiste)
     (download-all-songs (get-track-links tracklist artiste) tracklist album artiste)))
