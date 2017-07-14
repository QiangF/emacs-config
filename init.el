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
      (mapcar (lambda (p) (concat user-emacs-directory p))
	      '("config"
		"lisp"
		"lib/dash"
		"lib/with-editor"
		"lib/magit/lisp"
		"lib/volatile-highlights"
		"lib/multi-term"
		"lib/undo-tree"
		"lib/haskell-mode"
		"lib/anzu"
		"lib/helm"
		"lib/helm-gtags"
		"lib/mmm-mode"
		"lib/rust-mode"
		"lib/s"
		"lib/notmuch/emacs"
		"lib/magit"
		"lib/geiser/elisp"
		"lib/bb-mode"
		"lib/emacs-winum"
		"lib/emacs-noflet"
		"lib/disable-mouse"
		"lib/emacs-async"
		"lib/groovy-emacs-mode")))

(load "ui")
(load "my-helm")
(load "my-notmuch")
(load "my-easypg")
(load "my-tramp")
(load "my-multi-term")
(load "my-eshell")
(load "org-mode")
(load "my-magit")
(load "my-bb-mode")
(load "my-sh")
;(load "haskell")
(load "clang")
(load "python")
(load "my-rust")
(load "my-lilypond")
(load "my-groovy")
;(load "html")
;(load "w3m")

(mapc 'load (file-expand-wildcards (concat user-emacs-directory "load.d/*.el")))
