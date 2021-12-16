(require 'eshell)

(setq comint-prompt-read-only t)

(setq comint-output-filter-functions
      (remove 'ansi-color-process-output
	      comint-output-filter-functions))

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(require 'bash-completion)
(bash-completion-setup)

(defun kill-term-buffer-on-exit ()
  (let* ((buff (current-buffer))
         (proc (get-buffer-process buff)))
    (set-process-sentinel
     proc
     `(lambda (process event)
        (if (string= event "finished\n")
            (kill-buffer ,buff))))))

(add-hook 'term-exec-hook 'kill-term-buffer-on-exit)

(eval-after-load "term"
  '(define-key term-raw-map (kbd "C-c C-y") 'term-paste))

(define-key dired-mode-map (kbd "`") 'dired-open-term)

(defun terminal ()
  "Switch to terminal. Launch if nonexistent."
  (interactive)
  (if (get-buffer "*ansi-term*")
      (switch-to-buffer "*ansi-term*")
    (ansi-term "/bin/bash"))
  (get-buffer-process "*ansi-term*"))

(defalias 'tt 'terminal)

(defun dired-open-term ()
  "Open an `ansi-term' that corresponds to current directory."
  (interactive)
  (let ((current-dir (dired-current-directory)))
    (term-send-string
     (terminal)
     (if (file-remote-p current-dir)
         (let ((v (tramp-dissect-file-name current-dir t)))
           (format "ssh %s@%s\n"
                   (aref v 1) (aref v 2)))
       (format "cd '%s'\n" current-dir)))))
