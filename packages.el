(setq inhibit-default-init 1) ; don't load default.el

(add-to-list 'load-path "~/.emacs.d/local-packages/")

(require 'package)
(when (>= emacs-major-version 24) ; pkg mgmt introduced in emacs 24
  (add-to-list 'package-archives
;               '("melpa" . "http://melpa.milkbox.net/packages/") t))
               '("marmalade" . "http://marmalade-repo.org/packages/")) t)

(package-initialize) ; load and init all pkg's in package-load-list

;; required because of a package.el bug
;;(setq url-http-attempt-keepalives nil)

(defvar needed-packages
  '(volatile-highlights multi-term haskell-mode cc-mode zenburn-theme org-journal)
  "A list of packages to ensure are installed at launch.")

(require 'cl)

(defun all-packages-installed ()
  (loop for p in needed-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

; install missing packages (download from remote)
(defun install-packages ()
  (unless (all-packages-installed)
    (package-refresh-contents)
    (dolist (p needed-packages)
      (unless (package-installed-p p)
        (package-install p)))))

(install-packages)

(require 'org-journal)
(require 'volatile-highlights)
(require 'uniquify)
(require 'multi-term)
(require 'haskell-mode)
(require 'haskell-mode)
