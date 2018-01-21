(setq load-prefer-newer t)
(require 'find-lisp)
(let ((lisp-dir (concat user-emacs-directory "lisp")))
  (mapc 'load (sort (find-lisp-find-files lisp-dir "\\.el$") 'string<)))
