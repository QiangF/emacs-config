(require 'helm)
(require 'helm-config)
(require 'helm-semantic)

(setq helm-ff-transformer-show-only-basename nil
      helm-adaptive-history-file             "~/.emacs.d/data/helm-history"
      helm-yank-symbol-first                 t
      helm-move-to-line-cycle-in-source      t
      helm-buffers-fuzzy-matching            t
      helm-move-to-line-cycle-in-source      t
      helm-ff-auto-update-initial-value      t)

(global-set-key (kbd "C-h a")   'helm-apropos)
(global-set-key (kbd "C-h i")   'helm-info-emacs)
(global-set-key (kbd "C-h b")   'helm-descbinds)

(global-set-key (kbd "C-x b")   'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-r") 'helm-recentf)
(global-set-key (kbd "C-x r l") 'helm-filtered-bookmarks)
(global-set-key (kbd "M-y")     'helm-show-kill-ring)
(global-set-key (kbd "M-s o")   'helm-swoop)
(global-set-key (kbd "M-s /")   'helm-multi-swoop)
(global-set-key (kbd "M-x")     'helm-M-x)

(setq helm-M-x-fuzzy-match t)

(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)

(helm-mode t)
(helm-adaptative-mode t)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
