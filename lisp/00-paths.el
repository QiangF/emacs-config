(setq user-emacs-directory (expand-file-name user-emacs-directory)
      temporary-file-directory (concat user-emacs-directory "tmp/")
      config-file-directory (concat user-emacs-directory "config/")
      lib-file-directory (concat user-emacs-directory "lib")
      lisp-file-directory (concat user-emacs-directory "lisp"))

(let ((lib-paths (directory-files lib-file-directory t directory-files-no-dot-files-regexp))
      (non-std-lib-paths (mapcar (apply-partially 'concat user-emacs-directory)
				 '("lib/transient/lisp"
				   "lib/magit/lisp"
				   "lib/notmuch/emacs"
				   "lisp"))))
  (mapc (apply-partially 'add-to-list 'load-path) (append non-std-lib-paths lib-paths)))
