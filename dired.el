(require 'dired-x)

(setq dired-listing-switches "-alh")

(put 'dired-find-alternate-file 'disabled nil) ; allow 'a' cmd

(global-set-key (kbd "<f5>") 'dired-jump)
(global-set-key (kbd "<f6>") 'dired-jump-other-window)
