(defun pretty-print-dir (dir)
  (cond ((string-equal dir "/") "/")
	((string-equal dir (getenv "HOME")) "~")
	(t (car (last (split-string (eshell/pwd) "/"))))))

(setq eshell-prompt-function
  (lambda ()
    (concat "[" (getenv "USER") " " (pretty-print-dir (eshell/pwd)) "]"
	    (if (= (user-uid) 0) "# " "$ "))))

(defun eshell-clear-buffer ()
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

(add-hook 'eshell-mode-hook
	  '(lambda ()
	     (setq comint-scroll-show-maximum-output nil
		   comint-scroll-to-bottom-on-input nil
		   comint-scroll-to-bottom-on-output nil
		   comint-prompt-read-only t)
;	     (define-key eshell-mode-map "\C-l" 'eshell-clear-buffer)
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
