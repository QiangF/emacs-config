;; indent html using 4 spaces
(add-hook 'html-mode-hook
          (lambda()
            (setq sgml-basic-offset 4)
            (setq indent-tabs-mode nil)))
