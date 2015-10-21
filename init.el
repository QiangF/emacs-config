(setq inhibit-default-init 1)

(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file user-emacs-directory)))

(load-user-file "packages.el")
(load-user-file "ui.el")
(load-user-file "helm.el")
; (load-user-file "ibuffer.el")
(load-user-file "dired.el")
(load-user-file "multi-term.el")
(load-user-file "commands.el")
(load-user-file "gnus.el")
(load-user-file "easypg.el")
(load-user-file "org-mode.el")
;(load-user-file "haskell.el")
(load-user-file "cpp.el")
(load-user-file "python.el")
;(load-user-file "html.el")
;(load-user-file "gdb.el")
;(load-user-file "w3m.el")
;(load-user-file "newsticker.el")

; start emacsclient with: emacsclient -ce "(client-init)"
