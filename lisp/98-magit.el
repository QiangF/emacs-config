(require 'magit)
(require 'smerge-mode)

(global-set-key (kbd "C-x g") 'magit-status)

(setq magit-commit-arguments '("--signoff"))
