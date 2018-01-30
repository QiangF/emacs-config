(require 'dired-x)

(setq dired-listing-switches "-alh")

(put 'dired-find-alternate-file 'disabled nil) ; allow 'a' cmd

(define-key dired-mode-map (kbd "C-l") 'dired-jump)

(global-set-key (kbd "C-x C-f") 'dired-jump)
