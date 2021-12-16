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
