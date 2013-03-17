(defconst user-init-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'user-init-directory)
         user-init-directory)
        (t "~/.emacs.d/")))

(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file user-init-dir)))

(load-user-file "environement.el")
(load-user-file "ui.el")
(load-user-file "commands.el")
(load-user-file "personal.el")
(load-user-file "haskell.el")
(load-user-file "cpp.el")
(load-user-file "lisp.el")
(load-user-file "html.el")
(load-user-file "gdb.el")
