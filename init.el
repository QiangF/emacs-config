;(package-initipalize)

(load (concat user-emacs-directory "config/setup-environment"))

(require 'find-lisp)
(mapc 'load (find-lisp-find-files (concat user-emacs-directory "lisp") "\\.el$"))
