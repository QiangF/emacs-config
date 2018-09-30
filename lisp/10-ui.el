(setq inhibit-x-resources t)

(add-to-list 'custom-theme-load-path (expand-file-name "lib/zenburn" user-emacs-directory))
(load-theme 'zenburn t)

(setq inhibit-default-init t
      inhibit-startup-screen t
      inhibit-startup-buffer-menu t
      inhibit-message t)

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

(global-auto-revert-mode 1)

(require 'volatile-highlights)
(volatile-highlights-mode 1)

(require 'undo-tree)
(global-undo-tree-mode 1)

(menu-bar-mode 0)

(column-number-mode 1)
(line-number-mode 1)
(size-indication-mode 1)

(electric-pair-mode 1)
(show-paren-mode 1)

(delete-selection-mode 1)

(global-eldoc-mode -1)

(minibuffer-line-mode)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<up>") 'shrink-window)
(global-set-key (kbd "S-C-<down>") 'enlarge-window)

(setq enable-recursive-minibuffers t)

(setq help-window-select t)

(setq visible-bell t)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

(require 'shr)
(setq shr-use-colors nil)

(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(define-key ibuffer-mode-map (kbd "a") 'ibuffer-visit-buffer)

(setq-default mode-line-format nil)

(defun my-command-error-function (data context caller)
  "Don't print some error messages to the echo area"
  (when (not (memq (car data) '(buffer-read-only
				beginning-of-buffer
				end-of-buffer
				quit
				user-error)))
    (command-error-default-function data context caller)))

(setq command-error-function #'my-command-error-function)

(setq save-silently t)
(setq confirm-kill-processes nil)

(add-hook 'isearch-mode-hook
	  (lambda ()
	    (make-variable-buffer-local 'inhibit-message)
	    (setq inhibit-message nil)))

(global-set-key (kbd "C-x C-f") nil)

(require 'autorevert)
(setq auto-revert-verbose nil)

(set-display-table-slot standard-display-table 'vertical-border ?│)
(set-face-attribute 'vertical-border nil :foreground "#2B2B2B")
