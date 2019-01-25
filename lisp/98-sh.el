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

(add-hook 'shell-mode-hook
	  (lambda ()
	    (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t)))

(add-hook 'eshell-before-prompt-hook
 	  (lambda ()
 	    (setq xterm-color-preserve-properties t)))

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(require 'bash-completion)
(bash-completion-setup)
