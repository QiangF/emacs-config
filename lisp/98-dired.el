(require 'dired-x)

(setq dired-listing-switches "-alh"
      dired-recursive-deletes 'always)

(defun my-dired-open-external ()
  "In Dired, visit the file or directory named on this line."
  (interactive)
  (let* ((file_ext (file-name-extension (dired-get-filename 'no-dir) t))
	 (ext_list (append dired-guess-shell-alist-user
			   dired-guess-shell-alist-default))
	 (prog_val (catch 'prog_val
		     (mapc (lambda (x)
			     (let ((regex (car x))
				   (prog_val (cadr x)))
			       (when (string-match regex file_ext)
				 (throw 'prog_val prog_val))))
			   ext_list) nil)))
    (when (not prog_val)
      (setq prog_val (read-shell-command "Shell command: " nil nil)))
    (start-process prog_val nil prog_val (dired-get-filename))))

(define-key dired-mode-map "a" 'dired-find-file)
(define-key dired-mode-map "f" 'find-file)
(define-key dired-mode-map "o" 'my-dired-open-external)
(define-key dired-mode-map "c" 'find-file)

(define-key dired-mode-map (kbd "C-l") 'dired-jump)
(global-set-key (kbd "C-x l") 'dired-jump)
(global-set-key (kbd "C-x C-l") 'dired-jump)

(setq dired-guess-shell-alist-user '(("\\.pdf\\'" "evince")
                                     ("\\.doc?x\\'\\|\\.ppt?x\\'\\|\\.xls?x\\'" "libreoffice")
                                     ("\\.jpe?g\\'\\|\\.png\\'" "lximage-qt")
                                     ("\\.mpe?g\\'\\|\\.avi\\'\\|\\.mkv\\'\\|\\.mp4\\'" "vlc")))
