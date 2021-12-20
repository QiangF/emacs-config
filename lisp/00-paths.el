(setq user-emacs-directory (expand-file-name user-emacs-directory)
      config-file-directory (concat user-emacs-directory "config/")
      lib-file-directory (concat user-emacs-directory "lib")
      lisp-file-directory (concat user-emacs-directory "lisp")
      binary-file-directory (concat user-emacs-directory "bin"))

(let ((lib-paths (directory-files lib-file-directory t directory-files-no-dot-files-regexp))
      (non-std-lib-paths (mapcar (apply-partially 'concat user-emacs-directory)
				 '("lib/transient/lisp"
				   "lib/magit/lisp"
				   "lib/with-editor/lisp"
				   "lib/notmuch/emacs"
				   "lisp"))))
  (mapc (apply-partially 'add-to-list 'load-path) (append non-std-lib-paths lib-paths)))

(add-to-list 'exec-path binary-file-directory)

(unless (string-match-p (regexp-quote binary-file-directory) (getenv "PATH"))
  (setenv "PATH" (concat (getenv "PATH") ":" binary-file-directory)))

(require 'no-littering)
