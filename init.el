;(package-initialize)

(setq inhibit-default-init 1)

(defvar my-load-paths
  (mapcar (lambda (p) (concat user-emacs-directory p))
	  '("lisp"
	    "lib/dash"
	    "lib/with-editor"
	    "lib/magit/lisp"
	    "lib/volatile-highlights"
	    "lib/multi-term"
	    "lib/undo-tree"
	    "lib/haskell-mode")))

(mapc (lambda (p) (add-to-list 'load-path p)) my-load-paths)

(load "commands")
(load "packages")
(load "ui")
(load "my-helm")
; (load "ibuffer")
(load "my-multi-term")
;(load "gnus")
(load "pin-entry")
(load "org-mode")
(load "my-magit")
(load "haskell")
(load "cpp")
(load "python")
;(load "e-shell")
(load "sh")
;(load "notmuch")
;(load "html")
;(load "gdb")
;(load "w3m")
;(load "newsticker")

(mapc 'load (file-expand-wildcards (concat user-emacs-directory "load.d/*.el")))
