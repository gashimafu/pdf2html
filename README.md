# pdf2html

## purpose
 view pdf file as html file if possible.
 it's useful for remote tty -nw environment.
 it's emacs major mode.

## require
 pdftohtml unix command
 
## usage
 copy "pdf2html.el" to emacs load-path directory.
 add following lines in your init.el or something.

  (load "pdf2html")

  (pdf2html-install)

## effect
 When you open pdf file in local or internet,
 you will view the html converted one.

## reason for making
 for my study.
