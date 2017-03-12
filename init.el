;(package-initialize)

(setq inhibit-default-init 1
      load-prefer-newer t
      old-load-path load-path)

(mapc (apply-partially 'add-to-list 'old-load-path)
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
		"lib/notmuch"
		"lib/helm"
		"lib/helm-mt"
		"lib/helm-gtags"
		"lib/mmm-mode"
		"lib/rust-mode"
		"lib/s"
		"lib/notmuch/emacs"
		"lib/magit"
		"lib/geiser/elisp")))

(load "external-interaction")
(load "ui")
(load "my-helm")
(load "my-notmuch")
(load "my-easypg")
(load "my-tramp")
(load "my-multi-term")
(load "my-eshell")
(load "org-mode")
(load "my-magit")
;(load "haskell")
(load "clang")
(load "python")
(load "sh")
(load "my-rust")
;(load "html")
;(load "w3m")

(mapc 'load (file-expand-wildcards (concat user-emacs-directory "load.d/*.el")))
