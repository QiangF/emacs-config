(require 'package)
(require 'cl) ; clisp

;(add-to-list 'load-path "~/.emacs.d/local-packages/")

(when (>= emacs-major-version 24) ; pkg mgmt introduced in emacs 24
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			   ("marmalade" . "http://marmalade-repo.org/packages/")
			   ("melpa" . "http://melpa.milkbox.net/packages/"))))

(defvar needed-packages
  '(ggtags helm helm-gtags helm-mt))

(defun all-packages-installed ()
  (loop for p in needed-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

(defun install-packages ()
  (unless (all-packages-installed)
    (package-refresh-contents)
    (dolist (p needed-packages)
      (unless (package-installed-p p)
        (package-install p)))))

; enable packages only manually by calling package-initialize
(setq package-enable-at-startup nil)

(setq load-prefer-newer t)
(package-initialize)
(install-packages)
;(require 'auto-compile)
;(auto-compile-on-load-mode)
