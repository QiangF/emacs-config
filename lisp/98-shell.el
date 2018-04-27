(defun add-mode-line-dirtrack ()
  (setq mode-line-buffer-identification
        '(:propertize default-directory face mode-line-buffer-id)))

(add-hook 'shell-mode-hook 'add-mode-line-dirtrack)
