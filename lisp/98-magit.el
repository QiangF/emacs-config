(require 'magit)
(require 'smerge-mode)

(global-set-key (kbd "C-x g") 'magit-status)

(setq magit-commit-arguments '("--signoff"))

(set-face-attribute 'smerge-lower nil :background nil)
(set-face-attribute 'smerge-base nil :background nil)
(set-face-attribute 'smerge-upper nil :background nil)
