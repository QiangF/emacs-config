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

(load "ui")
(load "my-helm")
(load "my-notmuch")
(load "my-easypg")
(load "my-tramp")
(load "my-multi-term")
(load "my-pcomplete")
(load "my-eshell")
(load "org-mode")
(load "my-magit")
(load "my-bb-mode")
(load "my-sh")
(load "my-browser")
;(load "haskell")
(load "clang")
(load "python")
(load "my-rust")
(load "my-lilypond")
(load "my-groovy")
;(load "html")
;(load "w3m")

(mapc 'load (file-expand-wildcards (concat user-emacs-directory "load.d/*.el")))
