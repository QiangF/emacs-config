;(package-initialize)

(setq inhibit-default-init 1
      load-prefer-newer t)

(let ((libdir (concat user-emacs-directory "lib")))
  (mapc (apply-partially 'add-to-list 'load-path)
	(append (directory-files libdir t directory-files-no-dot-files-regexp)
		(mapcar (apply-partially 'concat user-emacs-directory)
			'("lib/magit/lisp"
			  "lib/notmuch/emacs"
			  "lib/geiser/elisp"
			  "lisp")))))

(require 'my-env)
(require 'find-lisp)
(mapc 'load (find-lisp-find-files (concat user-emacs-directory "lisp") "\\.el$"))
