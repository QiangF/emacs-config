;(package-initialize)

(setq inhibit-default-init 1)

(defun load-el-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file user-emacs-directory)))

(load-el-file "packages.el")
(load-el-file "ui.el")
(load-el-file "helm.el")
; (load-el-file "ibuffer.el")
(load-el-file "dired.el")
(load-el-file "multi-term.el")
(load-el-file "commands.el")
;(load-el-file "gnus.el")
;(load-private-config)
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

; start emacsclient with: emacsclient -ce "(client-init)"
