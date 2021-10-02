(require 'dired-x)

(defun get-buffer-filename-or-dirname ()
  (if (buffer-file-name)
      (buffer-file-name)
    (if (equal major-mode 'dired-mode)
	(dired-current-directory)
      nil)))

(defun is-tramp-path (path)
  (string-prefix-p "/ssh:" path))

(defun construct-sudo-filename (fullfile)
  (if (is-tramp-path fullfile)
      (let* ((tokens (split-string fullfile ":"))
	     (protocol (car tokens))
	     (user-host (cadr tokens))
	     (user-host-split (split-string user-host "@"))
	     (host (if (equal 1 (length user-host-split))
		       user-host (cadr user-host-split)))
	     (file (caddr tokens)))
	(concat protocol ":" user-host "|sudo:root@" host ":" file))
    (concat "/sudo:localhost:" fullfile)))

(defun root ()
  "Open current buffer as root"
  (interactive)
  (let* ((fullname (get-buffer-filename-or-dirname))
	 (already-sudo (string-match "sudo" fullname)))
    (when (and fullname (not already-sudo))
      (find-file (construct-sudo-filename fullname)))))
