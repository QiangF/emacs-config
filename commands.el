; Reload emacs init.el file
(defun reconfigure ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))

;; enable erase-buffer command
(put 'erase-buffer 'disabled nil)

(setq multi-term-program "/bin/bash")
(setq term-unbind-key-list '("C-z" "C-x" "C-c" "C-t" "C-h" "C-y" "C-v" "<ESC>")) ; combos to ignore

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

(defun open-in-external-app ()
  "Open the current file or dired marked files in external app."
  (interactive)
  (let ( doIt
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           (t (list (buffer-file-name))))))

    (setq doIt (if (<= (length myFileList) 5)
                   t
                 (y-or-n-p "Open more than 5 files?")))

    (when doIt
      (cond
       ((string-equal system-type "windows-nt")
        (mapc (lambda (fPath) (w32-shell-execute "open" (replace-regexp-in-string "/" "\\" fPath t t)) ) myFileList)
        )
       ((string-equal system-type "darwin")
        (mapc (lambda (fPath) (shell-command (format "open \"%s\"" fPath)) )  myFileList))
       ((string-equal system-type "gnu/linux")
        (mapc (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "xdg-open" fPath)) ) myFileList))))))

(defun open-in-filemanager ()
  "Show current file in desktop (OS's file manager)."
  (interactive)
  (cond
   ((string-equal system-type "windows-nt")
    (w32-shell-execute "explore" (replace-regexp-in-string "/" "\\" default-directory t t)))
   ((string-equal system-type "darwin") (shell-command "open ."))
   ((string-equal system-type "gnu/linux")
    (let ((process-connection-type nil)) (start-process "" nil "xdg-open" "."))
    ;; (shell-command "xdg-open .") ;; 2013-02-10 this sometimes froze emacs till the folder is closed. ⁖ with nautilus
    )))

(setq make-backup-files nil) ; stop creating those backup~ files
(setq auto-save-default nil) ; stop creating those #autosave# files

(defun make-backup ()
  "Make a backup copy of current file.

The backup file name has the form 「‹name›~‹timestamp›~」, in the same dir.
If such a file already exist, it's overwritten. (the timestamp includes seconds)
If the current buffer is not associated with a file, its a error."
  (interactive)
  (let ((currentFileName (buffer-file-name)) backupFileName)
    (setq backupFileName (concat currentFileName "~" (format-time-string "%Y%m%d_%H%M%S") "~"))
    (copy-file currentFileName backupFileName t)
    (message (concat "Backup saved as: " (file-name-nondirectory backupFileName)))))

(defun copy-line-or-region ()
  "Copy current line, or current text selection."
  (interactive)
  (if (region-active-p)
      (kill-ring-save (region-beginning) (region-end))
    (kill-ring-save (line-beginning-position) (line-beginning-position 2))))

(defun cut-line-or-region ()
  "Cut the current line, or current text selection."
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (kill-region (line-beginning-position) (line-beginning-position 2))))

(global-set-key (kbd "<f2>") 'cut-line-or-region) ; cut.
(global-set-key (kbd "<f3>") 'copy-line-or-region) ; copy.
(global-set-key (kbd "<f4>") 'yank) ; paste.

; Enable dired 'a' command
(put 'dired-find-alternate-file 'disabled nil)
