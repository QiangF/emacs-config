(setq inhibit-x-resources t)

(add-to-list 'custom-theme-load-path (expand-file-name "lib/zenburn" user-emacs-directory))
(load-theme 'zenburn t)

(setq inhibit-default-init t
      inhibit-startup-screen t
      inhibit-startup-buffer-menu t
      inhibit-message t)

(setq-default truncate-lines t)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq make-backup-files nil) ;don't create backup~
(setq auto-save-default nil) ;don't create #autosave#
(setq auto-save-list-file-prefix nil) ;don't create a list of auto-saved files

(put 'erase-buffer 'disabled nil) ;allow (erase-buffer)

(global-set-key (kbd "C-x k") 'kill-this-buffer)

(setq-default tab-width 8)

; set font on frames created with 'emacsclient'
(defun my-frame-set-font-hook (frame)
  (set-frame-font "DejaVu Sans Mono-12" t t))
(add-hook 'after-make-frame-functions 'my-frame-set-font-hook)

; set font in normal 'emacs' frames
(my-frame-set-font-hook (selected-frame))

(setq initial-scratch-message "")

(setq show-paren-style 'parenthesis)

(fset 'yes-or-no-p 'y-or-n-p)

(setq search-highlight t
      query-replace-highlight t
      case-fold-search t)

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position t)

(setq backup-by-copying-when-linked t
      backup-by-copying-when-mismatch t
      make-backup-files nil)

(setq recenter-positions '(top middle bottom))

(global-set-key (kbd "C-z") nil)

(blink-cursor-mode)

(setq global-auto-revert-non-file-buffers t)
(global-auto-revert-mode)

(require 'volatile-highlights)
(volatile-highlights-mode)

(require 'undo-tree)
(global-undo-tree-mode)

(require 'anzu)
(global-anzu-mode)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(column-number-mode)
(line-number-mode)
(size-indication-mode)

(electric-pair-mode)
(show-paren-mode)

(set-face-attribute 'fringe nil :background nil)
(fringe-mode 1)

(delete-selection-mode)

(global-eldoc-mode -1)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<up>") 'shrink-window)
(global-set-key (kbd "S-C-<down>") 'enlarge-window)

(setq enable-recursive-minibuffers t)

(setq help-window-select t)

(setq visible-bell nil)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

(require 'shr)
(setq shr-use-colors nil)

(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(define-key ibuffer-mode-map (kbd "a") 'ibuffer-visit-buffer)

(setq save-silently t)
(setq confirm-kill-processes nil)

(global-set-key (kbd "C-x C-f") nil)

(require 'autorevert)
(setq auto-revert-verbose nil)

(set-display-table-slot standard-display-table 'vertical-border ?│)
(set-face-attribute 'vertical-border nil :foreground "#2B2B2B")

(set-face-attribute 'mode-line nil :box nil)
(set-face-attribute 'mode-line-inactive nil :box nil)

(add-to-list 'completion-styles 'flex)

;; Avoid performance issues in files with very long lines.
(global-so-long-mode)

(auto-fill-mode -1)

(fido-mode)

(require 'yaml-mode)
