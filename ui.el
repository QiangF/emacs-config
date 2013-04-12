(setq inhibit-startup-screen 1) ; Do not show Welcome to emacs buffer

(global-font-lock-mode 1) ; Syntax coloring always on

(load-theme 'zenburn 1)

;; show either the file or buffer name as the frame title
(setq frame-title-format
      '(:eval (if (buffer-file-name)
                  (abbreviate-file-name (buffer-file-name)) "%b")))

; Search & scroll options
(setq search-highlight 1 ; Highlight matched string
      query-replace-highlight 1 ; Same as above for search + replace
      case-fold-search 1) ; Make search case insensitive
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

; Make fringes smaller
(if (fboundp 'fringe-mode)
    (fringe-mode 4))

(setq-default tab-width 8) ; Tabs are 8 chars in size
