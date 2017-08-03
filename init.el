;(package-initialize)

(setq inhibit-default-init 1
      load-prefer-newer t
      gc-cons-threshold most-positive-fixnum)

(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 800000)))

(setq user-emacs-directory (expand-file-name user-emacs-directory))
(setq temporary-file-directory (concat user-emacs-directory "tmp/"))
(setq config-file-directory (concat user-emacs-directory "config/"))
(setq exec-path (cons (concat user-emacs-directory "bin") exec-path))
(setenv "PATH" (concat (getenv "PATH") ":" user-emacs-directory "bin"))

(mapc (apply-partially 'add-to-list 'load-path)
      (append (directory-files (concat user-emacs-directory "lib") t directory-files-no-dot-files-regexp)
	      (mapcar (apply-partially 'concat user-emacs-directory)
		      '("config"
			"lisp"
			"lib/magit/lisp"
			"lib/notmuch/emacs"
			"lib/geiser/elisp"))))

(require 'find-lisp)
(mapc 'load (find-lisp-find-files (concat user-emacs-directory "lisp") "\\.el$"))
