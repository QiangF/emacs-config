(require 'multi-term)
(require 'helm-mt)
(require 'term)

(setq multi-term-program "/bin/bash")
(setq term-unbind-key-list '("C-z" "C-x" "C-c" "C-t" "C-h" "C-y" "C-v" "<ESC>"))

;(global-set-key (kbd "<f5>") 'multi-term)
;(global-set-key (kbd "C-x t") 'helm-mt)

(helm-mt/wrap-shells t)

(defun term-toggle-mode ()
  "Toggles term between line mode and char mode"
  (interactive)
  (if (term-in-line-mode)
      (term-char-mode)
    (term-line-mode)))

(define-key term-mode-map (kbd "C-c C-j") 'term-toggle-mode)
(define-key term-mode-map (kbd "C-c C-k") 'term-toggle-mode)
(define-key term-raw-map (kbd "C-c C-j") 'term-toggle-mode)
(define-key term-raw-map (kbd "C-c C-k") 'term-toggle-mode)
