(setq inhibit-startup-screen 1) ; Do not show Welcome to emacs buffer

(global-whitespace-mode 1)
(global-font-lock-mode 1) ; Syntax coloring always on

(load-theme 'zenburn 1)

;; Zenburn changes this, revert tab color to be consistent with whitespace mode
(set-face-foreground 'whitespace-tab "#4f4f4f")
(set-face-background 'whitespace-tab nil)
(set-face-background 'whitespace-space nil)
;;(set-face-foreground 'whitespace-indentation "#4f4f4f")
(set-face-background 'whitespace-indentation nil)
;;(set-face-foreground 'whitespace-space-after-tab "#4f4f4f")
(set-face-background 'whitespace-space-after-tab nil)
;;(set-face-foreground 'whitespace-trailing "#4f4f4f")
(set-face-background 'whitespace-trailing nil)

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
