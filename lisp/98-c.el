(setq-default c-basic-offset 8)

(add-hook 'initialization-hook
          (lambda ()
            (c-set-style "linux")))
