;(package-initialize)

(let* ((libdir (concat user-emacs-directory "lib"))
       (lib-paths (directory-files libdir t directory-files-no-dot-files-regexp))
       (non-std-lib-paths (mapcar (apply-partially 'concat user-emacs-directory)
			      '("lib/magit/lisp"
				"lib/notmuch/emacs"
				"lib/geiser/elisp"
				"lisp"))))
  (setq load-path (append load-path non-std-lib-paths lib-paths)))

(require 'my-env)
(require 'find-lisp)
(mapc 'load (find-lisp-find-files (concat user-emacs-directory "lisp") "\\.el$"))
