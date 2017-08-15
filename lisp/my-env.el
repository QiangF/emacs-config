(setq user-emacs-directory (expand-file-name user-emacs-directory))
(setq temporary-file-directory (concat user-emacs-directory "tmp/"))
(setq config-file-directory (concat user-emacs-directory "config/"))
(setq exec-path (cons (concat user-emacs-directory "bin") exec-path))

(let ((bindir (concat user-emacs-directory "bin"))
      (path (getenv "PATH")))
  (unless (string-match-p (regexp-quote bindir) path)
    (setenv "PATH" (concat path ":" bindir))))

(provide 'my-env)
