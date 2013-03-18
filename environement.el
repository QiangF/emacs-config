(setq inhibit-default-init 1) ; Do not load default.el
(setq inhibit-startup-screen 1) ; Do not show Welcome to emacs buffer

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

(require 'guru-mode)
(guru-global-mode 1)

(column-number-mode 1)
(line-number-mode 1)
(size-indication-mode 1)

; Preserve hard links + owner&group of the file being edited
(setq backup-by-copying-when-linked 1
      backup-by-copying-when-mismatch 1
      make-backup-files nil) ; Don't make backup files

(defalias 'list-buffers 'ibuffer) ; Use ibuffer for buffer management
(global-auto-revert-mode 1) ; Auto reload buffers when modified externally

(ido-mode 1)
(fset 'yes-or-no-p 'y-or-n-p) ; Ask for confirmation using single chars

; Generate buffer names using parent dir names
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(require 'multi-term)
;; Make multi-term ignore these key combinations, let emacs handle them
(setq term-unbind-key-list '("C-z" "C-x" "C-c" "C-h" "C-y" "C-v" "<ESC>"))

;; Disable guru-mode when in multi-term
(add-hook 'term-mode-hook 
          (lambda()
            (guru-mode 0)))

(setq tramp-default-method "ssh")
