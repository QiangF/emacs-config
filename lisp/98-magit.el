(require 'magit)
(require 'smerge-mode)

(global-set-key (kbd "C-x g") 'magit-status)

(setq magit-commit-arguments '("--signoff")
      transient-save-history nil
      with-editor-usage nil)

(remove-hook 'git-commit-setup-hook #'git-commit-turn-on-auto-fill)
(remove-hook 'git-commit-setup-hook #'bug-reference-mode)
(remove-hook 'git-commit-setup-hook #'with-editor-usage-message)
