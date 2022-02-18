#lang racket

(provide print-progress
         print-dots-cont
         print-logo-cont
         show)

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

(define (print-logo [l logo]) (printf "~a~n~n" l))
(define (print-logo-2 [l logo2]) (printf "~a~n~n" logo2))
(define (clear-all) (printf "\033[2J\033[H"))
(define (set-color color) (printf "~a" color))
(define green "\033[33m")
(define yellow "\033[34m")
(define red "\033[36m")


(define print-logo-cont
  (lambda ([n 0])
    (printf "\033[2J\033[H")
    (printf "\033[38;5;~am" (+ 190 (modulo n 30)))
    (print-logo-2)
    (sleep 0.5)
    (print-logo-cont (add1 n))))

(define show
  (lambda ([artiste #f] [albums #f] )
    (clear-all)
    (set-color green)
    (print-logo)
    (cond
      ((not artiste) (set-color yellow))
      ((not albums)
       (printf "Artist: ~a~n~n" artiste)
       (set-color red)       
       (printf "Choose albums:~n~n")
       (set-color yellow))
      (else
       (printf "Artist: ~a~n~n" artiste)
       (printf "Albums:~n")
       (map (lambda (a) (printf "~a~n" a)) albums)
       (set-color yellow)))))

(define album-done?
  (lambda (lt)
    (equal? (length lt) (length (filter thread-dead? lt)))))

(define num-done
  (lambda (t-lat)
    (length (filter album-done? t-lat))))

(define all-done?
  (lambda (t-lat)
    (equal? (length t-lat) (num-done t-lat))))

(define print-dots
  (lambda (n [max 4])
    (printf "\033[38;5;~am" (+ 190 (modulo n 30)))
    (printf "~n~nDownloading album(s)~a~n" (make-string  (modulo n max) #\.))
    ))

(define print-dots-cont
  (lambda (show-func [n 0])
    (show-func)
    (print-dots n)
    (sleep 0.5)
    (print-dots-cont show-func (add1 n))))


(define print-progress
  (lambda (t-lat [old-done 0])
    (cond
      ((all-done? t-lat) (sleep 2) (printf "\033[1F\033[2K\033[33mAll done~n"))
      ((equal? (num-done t-lat) old-done) (sleep 2) (print-progress t-lat old-done))
      (else (print-progress t-lat (num-done t-lat))))))
