(require 'volatile-highlights)
(require 'undo-tree)
(require 'anzu)
(require 'disable-mouse)

(add-to-list 'custom-theme-load-path (expand-file-name "lib/zenburn" user-emacs-directory))
(load-theme 'zenburn t)

(set-frame-font "DejaVu Sans Mono-11" t t)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq make-backup-files nil) ;don't create backup~
(setq auto-save-default nil) ;don't create #autosave#

(put 'erase-buffer 'disabled nil) ;allow (erase-buffer)

(global-set-key (kbd "C-x F") 'find-file-as-root)
(global-set-key (kbd "C-x k") 'kill-this-buffer)

(global-disable-mouse-mode)

; shut up 'got redefined' startup msgs
(setq ad-redefinition-action 'accept)

; use system clipboard
(setq select-enable-primary nil
      select-enable-clipboard t
      mouse-drag-copy-region t)

(setq-default bidi-display-reordering nil)

(setq-default tab-width 8)

(set-face-attribute 'default nil :height 120)

(setq inhibit-startup-screen 1
      inhibit-startup-buffer-menu t)

(setq initial-scratch-message "")

(setq show-paren-style 'parenthesis)

(fset 'yes-or-no-p 'y-or-n-p)

(setq search-highlight 1
      query-replace-highlight 1
      case-fold-search 1)

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(setq backup-by-copying-when-linked 1
      backup-by-copying-when-mismatch 1
      make-backup-files nil)

(setq recenter-positions '(top middle bottom))

(global-set-key (kbd "C-z") nil)

(setq global-auto-revert-non-file-buffers t)

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

(setq winum-keymap
      (let ((map (make-sparse-keymap)))
	(define-key map (kbd "C-`") 'winum-select-window-by-number)
	(define-key map (kbd "C-²") 'winum-select-window-by-number)
	(define-key map (kbd "M-0") 'winum-select-window-0-or-10)
	(define-key map (kbd "M-1") 'winum-select-window-1)
	(define-key map (kbd "M-2") 'winum-select-window-2)
	(define-key map (kbd "M-3") 'winum-select-window-3)
	(define-key map (kbd "M-4") 'winum-select-window-4)
	(define-key map (kbd "M-5") 'winum-select-window-5)
	(define-key map (kbd "M-6") 'winum-select-window-6)
	(define-key map (kbd "M-7") 'winum-select-window-7)
	(define-key map (kbd "M-8") 'winum-select-window-8)
	map))

(require 'winum)

(setq window-numbering-scope            'frame-local
      winum-auto-assign-0-to-minibuffer t
      winum-auto-setup-mode-line        t
      winum-mode-line-position          1)

(set-face-attribute 'winum-face nil :weight 'bold)

(winum-mode)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<up>") 'shrink-window)
(global-set-key (kbd "S-C-<down>") 'enlarge-window)

(global-unset-key "\C-x\o")

(setq font-lock-maximum-decoration nil)

(setq enable-recursive-minibuffers t)

(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)
