# lambda-dl
## About

This is a command line tool with a curses-like interface to quickly build a music library for offline enjoyment. This software is written in Racket with a very Scheme-ish style. There is a lot of refactoring left to do, and the code messy, but the software works well.

# Installation

Racket allows for some very nice cross-platform distribution. However, for now, only instructions for Arch based Linux distributions are provided.

## Installation (Arch based distros)

This software depends on yt-dlp (a fork of youtube-dl, which has throttling issues absent in yt-dlp). It is on the AUR, so to install one just has to do: 

```

yay -Sy yt-dlp

```

The Racket and the html-parsing package are also needed:

```

sudo pacman -Sy racket && raco pkg install html-parsing

```

Note that raco is Racket's package manager and will automatically be installed when Racket is intalled. This repository can then be cloned and an executable can be created by running the following command in whatever directory this repository was cloned in:

```

raco exe -o lambda-dl main.rkt

```

The executable is named lambda-dl and it can put it anywhere on your PATH.

## Using lambda-dl

Fire it up in a relatively big terminal window (confirmed works on st) and follow the promps to glory.
