(setq-default c-basic-offset 8)
(add-hook 'initialization-hook
          (lambda ()
            (c-set-style "linux")))

;; When the cursor is in a function, show the function name in the modeline
(which-function-mode 1)
