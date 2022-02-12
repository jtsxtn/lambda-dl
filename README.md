# lambda-dl
## About

This is a command line tool with a curses-like interface to quickly build a music library for offline enjoyment. This software is written in Racket with a very Scheme-ish style. There is a lot of refactoring left to do, and the code messy, but the software works well.

## Installation

To install you need the latest version of Racket and the html-parsing package:

```

sudo pacman -Sy racket && raco pkg install html-parsing

```

Note that raco is Racket's package manager and will automatically be installed when you install racket. You can then download this repository and create the executable:

```

raco exe -o lambda-dl main.rkt

```

The executable is named lambda-dl and you can put it anywhere on your PATH.

## Using lambda-dl

Fire it up in a relatively big terminal window (confirmed works on st) and follow the promps to glory.
