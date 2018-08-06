(require 'dired-x)

(setq dired-listing-switches "-alh"
      dired-recursive-deletes 'always)

(put 'dired-find-alternate-file 'disabled nil) ; allow 'a' cmd

(define-key dired-mode-map (kbd "C-l") 'dired-jump)
(global-set-key (kbd "C-x l") 'dired-jump)
(global-set-key (kbd "C-x C-l") 'dired-jump)
