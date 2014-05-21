(volatile-highlights-mode 1)

(load-theme 'zenburn 1)

(setq inhibit-startup-screen 1)

(blink-cursor-mode 0)

(setq-default major-mode 'org-mode)
;;(setq initial-buffer-choice "~/workspace/journal/TODO")

(global-font-lock-mode 1) ; syntax coloring is on if available
(global-auto-revert-mode 1) ; reload buffers if modifid externally
(global-hl-line-mode 1)

(fringe-mode 4)

(setq-default tab-width 8)

(electric-pair-mode 1)
(show-paren-mode 1)
(setq show-paren-style 'parenthesis)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(column-number-mode 1)
(line-number-mode 1)
(size-indication-mode 1)

(ido-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)

(setq frame-title-format
      '(:eval (if (buffer-file-name)
                  (abbreviate-file-name (buffer-file-name)) "%b")))

; make all buffer names unique
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(setq search-highlight 1
      query-replace-highlight 1
      case-fold-search 1)

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(setq backup-by-copying-when-linked 1
      backup-by-copying-when-mismatch 1
      make-backup-files nil)
