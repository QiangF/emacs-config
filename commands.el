; Reload emacs init.el file
(defun reconfigure ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))

;; enable erase-buffer command
(put 'erase-buffer 'disabled nil)

;; Delete current buffer
(defun delete-current-file (ξno-backup-p)
  "Delete the file associated with the current buffer.
   If no file is associated, just close buffer without prompt for save.
   A backup file is created with filename appended “~‹date time stamp›~”.
   when called with `universal-argument', don't create backup."
  (interactive "P")
  (let (fName)
    (when (buffer-file-name) ; buffer is associated with a file
      (setq fName (buffer-file-name))
      (save-buffer fName)
      (if ξno-backup-p
          (progn )
        (copy-file fName (concat fName "~" (format-time-string "%Y%m%d_%H%M%S") "~") t)
        )
      (delete-file fName)
      (message "「%s」 deleted." fName)
      )
    (kill-buffer (current-buffer))
    ))

(defun find-file-as-root ()
  "Like `ido-find-file, but automatically edit the file with
  root-privileges (using tramp/sudo), if the file is not writable by
  user."
  (interactive)
  (let ((file (ido-read-file-name "Edit as root: ")))
    (unless (file-writable-p file)
      (setq file (concat "/sudo:root@localhost:" file)))
    (find-file file)))

(global-set-key (kbd "C-x F") 'find-file-as-root)
