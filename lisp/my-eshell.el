(require 'eshell)
(require 'em-tramp)
(require 'em-term)

(defun pretty-print-dir (dir)
  (cond ((string-equal dir "/") "/")
	((string-equal dir (getenv "HOME")) "~")
	(t (car (last (split-string (eshell/pwd) "/"))))))

(setq eshell-prompt-function
      (lambda ()
	(concat "[" (getenv "USER") "@" system-name " "
		(pretty-print-dir (eshell/pwd)) "]"
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

;(global-set-key (kbd "C-!") 'eshell-here)

(global-set-key (kbd "C-x e") '(lambda () (interactive) (eshell t)))
; I usually mistype C-x e to C-x C-e
(global-unset-key (kbd "C-x C-e"))

(defun eshell/clear ()
  "Clears the shell buffer ala Unix's clear or DOS' cls"
  ;; the shell prompts are read-only, so clear that for the duration
  (let ((inhibit-read-only t))
    ;; simply delete the region
    (delete-region (point-min) (point-max))))

(defun eshell/emacs (&rest args)
  "Open a file in emacs. Some habits die hard."
  (if (null args)
      ;; If I just ran "emacs", I probably expect to be launching
      ;; Emacs, which is rather silly since I'm already in Emacs.
      ;; So just pretend to do what I ask.
      (bury-buffer)
    ;; We have to expand the file names or else naming a directory in an
    ;; argument causes later arguments to be looked for in that directory,
    ;; not the starting directory
    (mapc #'find-file (mapcar #'expand-file-name (eshell-flatten-list (reverse args))))))

(defalias 'eshell/e 'eshell/emacs)

(setq eshell-prefer-lisp-functions t
      eshell-prefer-lisp-variables t
      eshell-scroll-show-maximum-output nil
      eshell-hist-ignoredups t
      eshell-escape-control-x nil)

(setq comint-scroll-show-maximum-output nil
      comint-input-ignoredups t)

(setq eshell-command-aliases-list '(("sudo" "eshell/sudo $*")))

(setq eshell-directory-name (concat temporary-file-directory "eshell/"))
