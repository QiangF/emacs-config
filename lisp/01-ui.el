(setq inhibit-x-resources t)

(add-to-list 'custom-theme-load-path (expand-file-name "lib/zenburn" user-emacs-directory))
(load-theme 'zenburn t)

(setq inhibit-default-init t
      inhibit-startup-screen t
      inhibit-startup-buffer-menu t)

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
(global-font-lock-mode 1) ; syntax coloring on
(global-auto-revert-mode 1)

(require 'volatile-highlights)
(volatile-highlights-mode 1)

(require 'undo-tree)
(global-undo-tree-mode 1)

(require 'anzu)
(global-anzu-mode 1)

(menu-bar-mode 0)

(column-number-mode 1)
(line-number-mode 1)
(size-indication-mode 1)

(electric-pair-mode 1)
(show-paren-mode 1)

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
	(define-key map (kbd "M-9") 'winum-select-window-9)
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

(setq help-window-select t)

(require 'noflet)
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when Emacs exits."
  (noflet ((process-list ())) ad-do-it))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

(defun xah-delete-current-file-copy-to-kill-ring ()
  "Delete current buffer/file and close the buffer, push content to `kill-ring'.
URL `http://ergoemacs.org/emacs/elisp_delete-current-file.html'
Version 2016-07-20"
  (interactive)
  (progn
    (kill-new (buffer-string))
    (message "Buffer content copied to kill-ring.")
    (when (buffer-file-name)
      (when (file-exists-p (buffer-file-name))
        (progn
          (delete-file (buffer-file-name))
          (message "Deleted file: 「%s」." (buffer-file-name)))))
    (let ((buffer-offer-save nil))
      (set-buffer-modified-p nil)
      (kill-buffer (current-buffer)))))

(require 'shr)
(setq shr-use-colors nil)

(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(define-key ibuffer-mode-map (kbd "a") 'ibuffer-visit-buffer)

(setq-default mode-line-format
      '("%e" (:eval (winum-get-number-string))
	mode-line-front-space
	mode-line-mule-info mode-line-client
	mode-line-modified mode-line-remote "  "
	mode-line-buffer-identification
	" (%l,%c)  %p/%I  %m "
	(vc-mode vc-mode)))

(setq ido-save-directory-list-file (concat temporary-file-directory "ido.last")
      ido-enable-flex-matching t
      ido-create-new-buffer 'always)

(add-hook 'ido-make-file-list-hook 'ido-sort-mtime)
(add-hook 'ido-make-dir-list-hook 'ido-sort-mtime)

(ido-mode 1)
(ido-everywhere 1)

(require 'ido-completing-read+)
(ido-ubiquitous-mode 1)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command) ;; old M-x
(setq smex-save-file (concat temporary-file-directory "smex-data"))
