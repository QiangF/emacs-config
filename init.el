(setq inhibit-default-init 1) ; Do not load default.el
(setq inhibit-startup-screen 1) ; Do not show Welcome to emacs buffer

(setq user-full-name "Adi Ratiu")
(setq user-mail-address "adi@adirat.com")

; Disable editor menus, buttons and scrollbar
(when (fboundp 'tool-bar-mode) ; in a tty toolbarmode does not properly load
  (tool-bar-mode 0))
(menu-bar-mode 0)
(scroll-bar-mode 0)

; Reload emacs init.el file
(defun reconfigure ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))

; directory to search for manually added elisp files to load
(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins"))

(require 'package)
; If using at least emacs 24, search melpa for packages to install
(when (>= emacs-major-version 24)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/") t))

(package-initialize) ; try to load all latest packages that are installed

;; required because of a package.el bug
(setq url-http-attempt-keepalives nil)

(defvar needed-packages 
  '(magit volatile-highlights guru-mode multi-term haskell-mode cc-mode
          zenburn-theme)
  "A list of packages to ensure are installed at launch.")

(require 'cl)
; determine which of the needed packages are installed
(defun packages-installed-p ()
  (loop for p in needed-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

; install all missing packages, get them from remote repositories
(defun install-packages ()
  (unless (packages-installed-p)
    (package-refresh-contents)
    (dolist (p needed-packages)
      (unless (package-installed-p p)
        (package-install p)))))

(install-packages)

(global-whitespace-mode 1)
(global-font-lock-mode 1) ; Syntax coloring always on

(load-theme 'zenburn 1)

;; Zenburn changes this, revert tab color to be consistent with whitespace mode
(set-face-foreground 'whitespace-tab "#4f4f4f")

(require 'volatile-highlights)
(volatile-highlights-mode 1)

(require 'guru-mode)
(guru-global-mode 1)

;; show either the file or buffer name as the frame title
(setq frame-title-format
      '(:eval (if (buffer-file-name)
                  (abbreviate-file-name (buffer-file-name)) "%b")))

; Preserve hard links + owner&group of the file being edited
(setq backup-by-copying-when-linked 1
      backup-by-copying-when-mismatch 1
      make-backup-files nil) ; Don't make backup files

(column-number-mode 1)
(line-number-mode 1)
(size-indication-mode 1)

(defalias 'list-buffers 'ibuffer) ; Use ibuffer for buffer management
(global-auto-revert-mode 1) ; Auto reload buffers when modified externally

(ido-mode 1)
(fset 'yes-or-no-p 'y-or-n-p) ; Ask for confirmation using single chars

; Generate buffer names using parent dir names
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

; Search & scroll options
(setq search-highlight 1 ; Highlight matched string
      query-replace-highlight 1 ; Same as above for search + replace
      case-fold-search 1) ; Make search case insensitive
 (setq scroll-margin 0
       scroll-conservatively 100000
       scroll-preserve-screen-position 1)

(show-paren-mode 1) ; Enable matching highlight mode
(setq show-paren-style 'parenthesis) ; Highlight only matching paranthesis
(electric-pair-mode 1) ; Insert matching parenthesis, "'s etc

; Make fringes smaller
(if (fboundp 'fringe-mode)
    (fringe-mode 4))

(setq-default tab-width 8) ; Tabs are 8 chars in size

(blink-cursor-mode 0) ; Stop cursor blinking
(global-hl-line-mode 1) ; Highlight current line

(require 'magit)

;; Setup haskell-mode indentation type
(require 'haskell-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)

;; Customizations for CC Mode
(require 'cc-mode)
(setq-default c-basic-offset 8)
(add-hook 'initialization-hook
          (lambda ()
            (c-set-style "linux")))


;; Customizations for emacs-lisp mode
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)))

(require 'multi-term)
;; Make multi-term ignore these key combinations, let emacs handle them
(setq term-unbind-key-list '("C-z" "C-x" "C-c" "C-h" "C-y" "C-v" "<ESC>"))

;; Disable guru-mode when in multi-term
(add-hook 'term-mode-hook 
          (lambda()
            (guru-mode 0)
))

;; When the cursor is in a function, show the function name in the modeline
(which-function-mode 1)

;; xcscope isn't in the repos now so it should be in found in my-plugins
(require 'xcscope)

(setq tramp-default-method "ssh")

;; indent html using 4 spaces
(add-hook 'html-mode-hook
          (lambda()
            (setq sgml-basic-offset 4)
            (setq indent-tabs-mode nil)))

;; enable erase-buffer command
(put 'erase-buffer 'disabled nil)
