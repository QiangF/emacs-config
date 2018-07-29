;; always mark sh scripts executable on save
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(require 'bash-completion)
(bash-completion-setup)
