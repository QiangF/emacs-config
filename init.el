;(package-initipalize)

(load (concat user-emacs-directory "config/setup-env"))

(require 'find-lisp)
(mapc 'load (find-lisp-find-files lisp-file-directory "\\.el$"))
