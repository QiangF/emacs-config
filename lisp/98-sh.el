(require 'xterm-color)
(require 'eshell)

(setenv "TERM" "st-256color")

(setq comint-terminfo-terminal "st-256color"
      comint-prompt-read-only t)

(setq comint-output-filter-functions
      (remove 'ansi-color-process-output
	      comint-output-filter-functions))

(setq eshell-output-filter-functions
      (remove 'eshell-handle-ansi-color
	      eshell-output-filter-functions))

(add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)

(defun clear-shell-screen ()
  (interactive)
  (end-of-buffer)
  (recenter-top-bottom 0))

(add-hook 'shell-mode-hook
	  (lambda ()
	    (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t)
	    (font-lock-mode 0)
	    (define-key comint-mode-map "\C-l" 'clear-shell-screen)))

(add-hook 'eshell-before-prompt-hook
	  (lambda ()
	    (setq xterm-color-preserve-properties t)
	    (font-lock-mode 0)))

(add-hook 'term-mode-hook
	  (lambda ()
	    (font-lock-mode 0)) t)

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(require 'bash-completion)
(bash-completion-setup)
