(setq inhibit-default-init 1) ; Do not load default.el
(setq inhibit-startup-screen 1) ; Do not show Welcome to emacs buffer

(setq user-full-name "Adi Ratiu")
(setq user-mail-address "adi@adirat.com")

; Disable editor menus, buttons and scrollbar
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; Find and edit a file as superuser
(defun sudo-find (&optional arg)
  (interactive "p")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

; Reload emacs init.el file
(defun reconfigure ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))

; directory to search for manually added elisp files to load
(add-to-list 'load-path (expand-file-name "~/.emacs.d/my-plugins"))

(require 'package)
; If using at least emacs 24, search melpa for packages to install
(when (>= emacs-major-version 24)
  (add-to-list 'package-archives
	       '("melpa" . "http://melpa.milkbox.net/packages/") t))

(package-initialize) ; try to load all latest packages that are installed

;; required because of a package.el bug
(setq url-http-attempt-keepalives nil)

(defvar needed-packages
  '(guru-mode volatile-highlights multi-term zenburn-theme)
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

(load-theme 'zenburn 1)

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

; Disable whitespace mode globally because it interferes with the themes
(global-whitespace-mode -1)
(global-font-lock-mode 1) ; Syntax coloring always on

(setq-default tab-width 8) ; Tabs are 8 chars in size
