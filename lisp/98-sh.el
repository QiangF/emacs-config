(require 'xterm-color)
(require 'eshell)

(setq comint-prompt-read-only t)

(setq comint-output-filter-functions
      (remove 'ansi-color-process-output
	      comint-output-filter-functions))

(add-hook 'shell-mode-hook
	  (lambda ()
	    (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t)))

(add-hook 'eshell-before-prompt-hook
 	  (lambda ()
 	    (setq xterm-color-preserve-properties t)))

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(add-hook 'shell-mode-hook  'with-editor-export-editor)
(add-hook 'term-exec-hook   'with-editor-export-editor)
(add-hook 'eshell-mode-hook 'with-editor-export-editor)

(require 'bash-completion)
(bash-completion-setup)
