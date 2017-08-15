(setq user-emacs-directory (expand-file-name user-emacs-directory)
      temporary-file-directory (concat user-emacs-directory "tmp/")
      config-file-directory (concat user-emacs-directory "config/")
      lib-file-directory (concat user-emacs-directory "lib")
      binary-file-directory (concat user-emacs-directory "bin"))

(setq exec-path (cons binary-file-directory exec-path))

(unless (string-match-p (regexp-quote binary-file-directory) (getenv "PATH"))
  (setenv "PATH" (concat (getenv "PATH") ":" binary-file-directory)))

(let ((lib-paths (directory-files lib-file-directory t directory-files-no-dot-files-regexp))
      (non-std-lib-paths (mapcar (apply-partially 'concat user-emacs-directory)
			      '("lib/magit/lisp"
				"lib/notmuch/emacs"
				"lib/geiser/elisp"
				"lisp"))))
  (setq load-path (append load-path non-std-lib-paths lib-paths)))
