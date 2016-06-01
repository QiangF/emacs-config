(when window-system
  (setq gnus-sum-thread-tree-indent "  ")
  (setq gnus-sum-thread-tree-root "") ;; "● ")
  (setq gnus-sum-thread-tree-false-root "") ;; "◯ ")
  (setq gnus-sum-thread-tree-single-indent "") ;; "◎ ")
  (setq gnus-sum-thread-tree-vertical        "│")
  (setq gnus-sum-thread-tree-leaf-with-other "├─► ")
  (setq gnus-sum-thread-tree-single-leaf     "╰─► "))

(setq gnus-summary-line-format
      (concat
       "%0{%U%R%z%}"
       "%3{│%}" "%1{%d%}" "%3{│%}" ;; date
       "  "
       "%4{%-20,20f%}"               ;; name
       "  "
       "%3{│%}"
       " "
       "%1{%B%}"
       "%s\n"))

(setq gnus-summary-display-arrow t)

(setq mm-discouraged-alternatives '("text/html" "text/richtext"))

(setq gnus-init-file nil)
