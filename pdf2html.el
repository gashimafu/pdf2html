;;; pdf2html.el
;;
;; simple pdf viewer in emacs eww buffer
;; for both local file and remove internet file
;;
;; Copyright (C) 2022 BIST
;;
;; Author: Nagashima Fumio
;; Maintainer: Nagashima Fumio
;; Created: May 8, 2022
;; Modified:
;; Version: 0.0.0
;; Keywords: convenience tools
;;
;; Package-Requires: emacs 28.1
;;
;; This file is not part of GNU Emacs.
;;
;; Required Software : pdftohtml
;;
;; USAGE:
;; - Copy this file to emacs load-path directory.
;; - Add followings in init.el.
;;    (load "pdf2html")
;;    (pdf2html-install)

;;
;; working directory
;;
(defvar pdf2html-working-directory nil
  "working directory path name")

(defun pdf2html-create-working-directory ()
  "create working directory if not exist"
  (unless pdf2html-working-directory
    (setq pdf2html-working-directory (make-temp-name "/tmp/pdf2html_"))
    (make-directory pdf2html-working-directory)))

(defun pdf2html-delete-working-directory ()
  "delete working directory if exist"
  (when pdf2html-working-directory
    (delete-directory pdf2html-working-directory t)
    (setq pdf2html-working-directory nil)))

;;
;; main 
;;
(define-derived-mode pdf2html-mode html-mode "pdf2html"
  "convert pdf to html using pdftohtml unix command 
with a working file because severel hyperlink-jump to itself.
And finally it will be rendered by eww-open-file emacs Lisp function."
  (set-buffer-multibyte t)
  (setq tmpfile (make-temp-file (concat pdf2html-working-directory "/") nil ".html"))
  (let ((command (format "pdftohtml -i -s -noframes - %s" tmpfile)))
;    (message "pdf2html cmd :\"%s\"" command)
    (shell-command-on-region
     (point-min) (point-max)
     command nil t
     "*pdf2html error*" t
     ))
  (eww-open-file tmpfile)
  (kill-buffer (previous-buffer)))

;;
;; initialize 
;;
(defun pdf2html-install ()
  "add pdf2txt entry to auto-mode-alist, magic-mode-alist, mailcap-usermime-data,
create working directory and add its postprosess to kill-emacs-hook"
  (interactive)
  (unless pdf2html-working-directory
    (pdf2html-create-working-directory)
    (add-hook 'kill-emacs-hook 'pdf2html-delete-working-directory)
    (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf2html-mode))
    (add-to-list 'magic-mode-alist '("%PDF" . pdf2html-mode))
    (add-to-list 'mailcap-user-mime-data '((viewer . pdf2html-mode) (type . "application/pdf")))))
