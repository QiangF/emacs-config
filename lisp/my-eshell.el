(require 'eshell)
(require 'em-tramp)

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

;; (remove-hook 'comint-output-filter-functions
;; 	     'comint-postoutput-scroll-to-bottom)
;; (remove-hook 'comint-output-filter-functions
;; 	     'comint-watch-for-password-prompt)

;; (setq comint-scroll-to-bottom-on-input nil ;; always insert at the bottom
;;       ;; always add output at the bottom
;;       comint-scroll-to-bottom-on-output nil
;;       ;; scroll to show max possible output
;;       comint-scroll-show-maximum-output nil
;;       ;; no duplicates in command history
;;       comint-input-ignoredups t
;;       ;; insert space/slash after file completion
;;       comint-completion-addsuffix t
;;       ;; if this is t, it breaks shell-command
;;       comint-prompt-read-only nil)

;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

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
;(setq scroll-step 1)
;(setq scroll-conservatively 10000)
;(setq auto-window-vscroll nil)

;(add-to-list 'eshell-visual-commands "ssh")

;; (defun eshell-here ()
;;   "Opens up a new shell in the directory associated with the
;; current buffer's file. The eshell is renamed to match that
;; directory to make multiple eshell windows easier."
;;   (interactive)
;;   (let* ((parent (if (buffer-file-name)
;;                      (file-name-directory (buffer-file-name))
;;                    default-directory))
;;          (height (/ (window-total-height) 3))
;;          (name   (car (last (split-string parent "/" t)))))
;;     (split-window-vertically (- height))
;;     (other-window 1)
;;     (eshell "new")
;;     (rename-buffer (concat "*eshell: " name "*"))))

;; (global-set-key (kbd "C-!") 'eshell-here)

;(remove-hook 'comint-output-filter-functions 'comint-postoutput-scroll-to-bottom)
;(remove-hook 'comint-output-filter-functions 'ansi-color-process-output)

(setq eshell-scroll-show-maximum-output nil)

(setq eshell-prefer-lisp-functions t)
(setq eshell-prefer-lisp-variables t)

(setq eshell-hist-ignoredups t)
