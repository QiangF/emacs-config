(require 'eshell)
(require 'em-tramp)
(require 'em-term)

(defun pretty-print-dir (dir)
  (cond ((string-equal dir "/") "/")
	((string-equal dir (getenv "HOME")) "~")
	(t (car (last (split-string (eshell/pwd) "/"))))))

(setq eshell-prompt-function
      (lambda ()
	(concat (pretty-print-dir (eshell/pwd))
		(if (= (user-uid) 0) "# " "$ "))))

(setq eshell-prompt-regexp "^.+[#$] ")

(defun eshell-maybe-bol ()
  (interactive)
  (let ((p (point)))
    (eshell-bol)
    (if (= p (point))
	(beginning-of-line))))

(defun compare-char-before (pos char-to-compare)
  (char-equal char-to-compare (char-before (- (point) pos))))

(defun eshell-quick-exit-or-del ()
  (interactive)
  (if (not (and (eolp)
		(compare-char-before 0 ?\s)
		(or (compare-char-before 1 ?$)
		    (compare-char-before 1 ?#))))
      (delete-char 1)
    (insert "exit")
    (eshell-send-input)))

(add-hook 'eshell-mode-hook
	  '(lambda ()
	     (define-key eshell-mode-map "\C-d" 'eshell-quick-exit-or-del)
	     (define-key eshell-mode-map "\C-a" 'eshell-maybe-bol)))

(add-to-list 'eshell-visual-commands "ssh")
(add-to-list 'eshell-visual-subcommands
	     '("git" "log" "diff" "show"))

(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (name   (car (last (split-string parent "/" t)))))
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))))

(global-set-key (kbd "C-!") 'eshell-here)

(setq eshell-prefer-lisp-functions t
      eshell-prefer-lisp-variables t
      eshell-scroll-show-maximum-output nil
      eshell-hist-ignoredups t)

(setq comint-scroll-show-maximum-output nil
      comint-input-ignoredups t)
