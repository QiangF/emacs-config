(require 'ggtags)

(setq-default c-basic-offset 8)

(add-hook 'initialization-hook
          (lambda ()
            (c-set-style "linux")))

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(which-function-mode 1)
