(require 'magit)

(global-set-key (kbd "C-x g") 'magit-status)

(setq magit-commit-arguments '("--signoff"))

(setq magit-completing-read-function 'magit-ido-completing-read)
