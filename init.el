;(package-initipalize)

(load (concat user-emacs-directory "config/setup-environment"))

(require 'find-lisp)
(mapc 'load (find-lisp-find-files lisp-file-directory "\\.el$"))
