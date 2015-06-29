(require 'multi-term)

(setq multi-term-program "/bin/bash")
(setq term-unbind-key-list '("C-z" "C-x" "C-c" "C-t" "C-h" "C-y" "C-v" "<ESC>"))

(global-set-key (kbd "<f5>") 'multi-term)
(global-set-key (kbd "<f6>") 'multi-term-prev)
(global-set-key (kbd "<f7>") 'multi-term-next)
