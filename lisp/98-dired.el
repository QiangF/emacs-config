(require 'dired-x)

(setq dired-listing-switches "-alh"
      dired-recursive-deletes 'always)

(define-key dired-mode-map (kbd "C-l") 'dired-jump)
(global-set-key (kbd "C-x l") 'dired-jump)
(global-set-key (kbd "C-x C-l") 'dired-jump)

(define-key dired-mode-map "a" 'dired-find-file)
(define-key dired-mode-map "f" 'find-file)

  (interactive)


(define-key dired-mode-map (kbd "c") 'find-file)
