(setq inhibit-default-init 1) ; Do not load default.el

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
