(require 'dired-x)

(setq dired-listing-switches "-alh"
      dired-recursive-deletes 'always)

(put 'dired-find-alternate-file 'disabled nil) ; allow 'a' cmd

(global-set-key (kbd "C-l") 'dired-jump)
(global-set-key (kbd "C-x C-f") nil)
