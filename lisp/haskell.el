(require 'haskell-mode)

(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(add-to-list 'completion-ignored-extensions ".hi")
(add-to-list 'completion-ignored-extensions ".dyn_hi")
(add-to-list 'completion-ignored-extensions ".dyn_o")
