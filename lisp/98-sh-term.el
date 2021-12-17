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

(define-key dired-mode-map (kbd "`") 'aratiu/terminal)

(defun aratiu/terminal (&optional path name)
  "Opens a terminal at PATH. If no PATH is given, it uses
the value of `default-directory'. PATH may be a tramp remote path.
The term buffer is named based on `name' "
  (interactive)
  (require 'term)
  (unless path (setq path default-directory))
  (unless name (setq name "term"))
  (let ((path (replace-regexp-in-string "^file:" "" path))
	(cd-str "fn=%s; if test ! -d $fn; then fn=$(dirname $fn); fi; cd $fn; exec bash")
	(start-term (lambda (termbuf)
		      (progn
			(set-buffer termbuf)
			(term-mode)
			(term-char-mode)
			(switch-to-buffer termbuf)))))
    (if (tramp-tramp-file-p path)
	(let* ((tstruct (tramp-dissect-file-name path))
	       (cd-str-ssh (format cd-str (tramp-file-name-localname tstruct)))
	       (user (if (tramp-file-name-user tstruct)
			 (tramp-file-name-user tstruct)
		       user-login-name))
	       (switches (list "-l" user
			       "-t" (tramp-file-name-host tstruct)
			       cd-str-ssh))
	       (termbuf (apply 'make-term name "ssh" nil switches)))
	  (cond
	   ((equal (tramp-file-name-method tstruct) "ssh")
	    (funcall start-term termbuf))
	   (t (error "not implemented for method %s"
		     (tramp-file-name-method tstruct)))))
      (let* ((cd-str-local (format cd-str path))
	     (termbuf (apply 'make-term name "/bin/sh" nil (list "-c" cd-str-local))))
	(funcall start-term termbuf)))))

(defun my-term-use-utf8 ()
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(add-hook 'term-exec-hook 'my-term-use-utf8)
