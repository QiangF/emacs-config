(defun pretty-print-dir (dir)
  (cond ((string-equal dir "/") "/")
	((string-equal dir (getenv "HOME")) "~")
	(t (car (last (split-string (eshell/pwd) "/"))))))

(setq eshell-prompt-function
  (lambda ()
    (concat "[" (getenv "USER") " " (pretty-print-dir (eshell/pwd)) "]"
	    (if (= (user-uid) 0) "# " "$ "))))

(defun eshell-erase-buffer ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input nil nil t)))

(defun eshell-maybe-bol ()
      (interactive)
      (let ((p (point)))
        (eshell-bol)
        (if (= p (point))
            (beginning-of-line))))

(defun eshell-exit ()
  (interactive)
  (insert "exit")
  (eshell-send-input)
  (delete-window))

(add-hook 'eshell-mode-hook
	  '(lambda ()
	     (setq comint-scroll-show-maximum-output nil
		   comint-scroll-to-bottom-on-input nil
		   comint-scroll-to-bottom-on-output nil
		   comint-prompt-read-only t)
	     (define-key eshell-mode-map "\C-d" 'eshell-exit)
	     (define-key eshell-mode-map "\C-a" 'eshell-maybe-bol)))

(remove-hook 'comint-output-filter-functions
	     'comint-postoutput-scroll-to-bottom)
(remove-hook 'comint-output-filter-functions
	     'comint-watch-for-password-prompt)

(setq eshell-prompt-regexp "^\\[[^#$\n]*\\][#$] ")

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; (defun set-scroll-conservatively ()
;;   "Add to shell-mode-hook to prevent jump-scrolling on newlines in shell buffers."
;;   (set (make-local-variable 'scroll-conservatively) 10))
;; (add-hook 'shell-mode-hook 'set-scroll-conservatively)


;; ;; eshell scrolling betterness
;; (defun eshell-scroll-to-bottom (window display-start)
;;   (if (and window (window-live-p window))
;;       (let ((resize-mini-windows nil))
;; 	(save-selected-window
;; 	  (select-window window)
;; 	  (save-restriction
;; 	    (widen)
;; 	    (save-excursion
;; 	      (recenter -7)
;; 	      (sit-for 0)))))))

;; (defun eshell-add-scroll-to-bottom ()
;;   (interactive)
;;   ;(make-local-hook 'window-scroll-functions)
;;   (add-hook 'window-scroll-functions 'eshell-scroll-to-bottom nil t))

;;(add-hook 'eshell-mode-hook 'eshell-add-scroll-to-bottom)
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)
;(add-to-list 'eshell-visual-commands "ssh")

(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))))

(global-set-key (kbd "C-!") 'eshell-here)