(require 'volatile-highlights)
(require 'undo-tree)
(require 'windmove)
(require 'anzu) ; prvides more isearch info

;(add-to-list 'default-frame-alist '(background-color . "#E2E2E2E2"))

(add-to-list 'custom-theme-load-path (expand-file-name "lib/zenburn" user-emacs-directory))
(load-theme 'zenburn t)

(set-frame-font "DejaVu Sans Mono-11" t t)
(add-to-list 'default-frame-alist '(height . 42))
(add-to-list 'default-frame-alist '(width . 80))

; shut up 'got redefined' startup msgs
(setq ad-redefinition-action 'accept)

(setq-default bidi-display-reordering nil)

(setq-default tab-width 8)

(set-face-attribute 'default nil :height 120)

(setq inhibit-startup-screen 1)

;; (setq-default major-mode 'org-mode)
;; (add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))
;; (setq initial-buffer-choice "~/workspace/journal/TODO")

(setq show-paren-style 'parenthesis)

(fset 'yes-or-no-p 'y-or-n-p)

(setq frame-title-format
      '(:eval (if (buffer-file-name)
                  (abbreviate-file-name (buffer-file-name)) "%b")))

(setq search-highlight 1
      query-replace-highlight 1
      case-fold-search 1)

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(setq backup-by-copying-when-linked 1
      backup-by-copying-when-mismatch 1
      make-backup-files nil)

;; make a shell script executable automatically on save
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(global-set-key (kbd "C-z") nil)

(blink-cursor-mode 0)
(global-font-lock-mode 1) ; syntax coloring on
(global-auto-revert-mode 1)
(volatile-highlights-mode 1)
(global-undo-tree-mode 1)
(global-anzu-mode 1)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(column-number-mode 1)
(line-number-mode 1)
(size-indication-mode 1)

(electric-pair-mode 1)
(show-paren-mode 1)

(fringe-mode 4)

(delete-selection-mode 1)

(windmove-default-keybindings)

;(global-hl-line-mode 1)

(setq font-lock-maximum-decoration nil)
