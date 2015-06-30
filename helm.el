(require 'helm)
(require 'helm-config)
(require 'helm-semantic)
(require 'helm-gtags)

(setq helm-ff-transformer-show-only-basename nil
      helm-adaptive-history-file             "~/.emacs.d/data/helm-history"
      helm-yank-symbol-first                 t
      helm-move-to-line-cycle-in-source      t
      helm-buffers-fuzzy-matching            t
      helm-move-to-line-cycle-in-source      t
      helm-ff-auto-update-initial-value      t
      helm-quick-update                      t
      helm-split-window-in-side-p            t
      helm-gtags-auto-update                 t
      helm-gtags-use-input-at-cursor         t
      helm-gtags-pulse-at-cursor             t
      helm-gtags-suggested-key-mapping       t
      helm-gtags-ignore-case                 t)

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

;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
