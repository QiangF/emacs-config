(require 'xterm-color)
(require 'eshell)

(setenv "TERM" "st-256color")

(setq comint-terminfo-terminal "st-256color"
      comint-prompt-read-only t)

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

(define-key (current-global-map)
  [remap async-shell-command] 'with-editor-async-shell-command)
(define-key (current-global-map)
    [remap shell-command] 'with-editor-shell-command)

(add-hook 'shell-mode-hook  'with-editor-export-editor)
(add-hook 'term-exec-hook   'with-editor-export-editor)
(add-hook 'eshell-mode-hook 'with-editor-export-editor)

(require 'bash-completion)
(bash-completion-setup)
