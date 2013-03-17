; Disable editor menus, buttons and scrollbar
(when (fboundp 'tool-bar-mode) ; in a tty toolbarmode does not properly load
  (tool-bar-mode 0))
(menu-bar-mode 0)
(scroll-bar-mode 0)

(global-whitespace-mode 1)
(global-font-lock-mode 1) ; Syntax coloring always on

(load-theme 'zenburn 1)

;; Zenburn changes this, revert tab color to be consistent with whitespace mode
(set-face-foreground 'whitespace-tab "#4f4f4f")

(require 'volatile-highlights)
(volatile-highlights-mode 1)

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

(show-paren-mode 1) ; Enable matching highlight mode
(setq show-paren-style 'parenthesis) ; Highlight only matching paranthesis
(electric-pair-mode 1) ; Insert matching parenthesis, "'s etc

; Make fringes smaller
(if (fboundp 'fringe-mode)
    (fringe-mode 4))

(setq-default tab-width 8) ; Tabs are 8 chars in size

(blink-cursor-mode 0) ; Stop cursor blinking
(global-hl-line-mode 1) ; Highlight current line
