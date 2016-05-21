;(package-initialize)

(setq inhibit-default-init 1)

(defun load-el-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file user-emacs-directory)))

(defun add-to-load-path (path)
  (interactive "f")
  "Add a path relative to user-emacs-directory to load-path"
  (add-to-list 'load-path (expand-file-name path user-emacs-directory)))

(add-to-load-path "lib/dash")
(add-to-load-path "lib/with-editor")
(add-to-load-path "lib/magit/lisp")

(load-el-file "packages.el")
(load-el-file "ui.el")
(load-el-file "helm.el")
; (load-el-file "ibuffer.el")
(load-el-file "dired.el")
(load-el-file "multi-term.el")
(load-el-file "commands.el")
;(load-el-file "gnus.el")
(load-private-config)
(load-el-file "pinentry.el")
(load-el-file "org-mode.el")
(load-el-file "magit.el")
;(load-el-file "haskell.el")
(load-el-file "cpp.el")
(load-el-file "python.el")
;(load-el-file "eshell.el")
(load-el-file "sh.el")
;(load-el-file "notmuch.el")
;(load-el-file "html.el")
;(load-el-file "gdb.el")
;(load-el-file "w3m.el")
;(load-el-file "newsticker.el")

; load custom local configs under ~/.emacs.d/load.d
(require 'load-dir)
(setq load-dirs t)
