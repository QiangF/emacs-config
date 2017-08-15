(setq user-emacs-directory (expand-file-name user-emacs-directory)
      temporary-file-directory (concat user-emacs-directory "tmp/")
      config-file-directory (concat user-emacs-directory "config/")
      binary-file-directory (concat user-emacs-directory "bin"))

(setq exec-path (cons binary-file-directory exec-path))

(unless (string-match-p (regexp-quote binary-file-directory) (getenv "PATH"))
  (setenv "PATH" (concat (getenv "PATH") ":" binary-file-directory)))
