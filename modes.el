; Disable editor menus, buttons and scrollbar
(when (fboundp 'tool-bar-mode) ; in a tty toolbarmode does not properly load
      (tool-bar-mode 0))

(menu-bar-mode 0)
(scroll-bar-mode 0)

(column-number-mode 1)
(line-number-mode 1)
(size-indication-mode 1)

(blink-cursor-mode 0) ; Stop cursor blinking
(global-hl-line-mode 1) ; Highlight current line

(show-paren-mode 1) ; Enable matching highlight mode
(setq show-paren-style 'parenthesis) ; Highlight only matching paranthesis
(electric-pair-mode 1) ; Insert matching parenthesis, "'s etc

(ido-mode 1)
(fset 'yes-or-no-p 'y-or-n-p) ; Ask for confirmation using single chars

; Generate buffer names using parent dir names
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(require 'multi-term)
(setq multi-term-program "/bin/bash") ; use bash shell in terminals
;; Make multi-term ignore these key combinations, let emacs handle them
(setq term-unbind-key-list '("C-z" "C-x" "C-c" "C-h" "C-y" "C-v" "<ESC>"))

; Preserve hard links + owner&group of the file being edited
(setq backup-by-copying-when-linked 1
      backup-by-copying-when-mismatch 1
      make-backup-files nil) ; Don't make backup files

(defalias 'list-buffers 'ibuffer) ; Use ibuffer for buffer management
(setq ibuffer-expert 1) ; Don't ask for permission when deleting buffers
(setq ibuffer-show-empty-filter-groups nil)

(setq ibuffer-saved-filter-groups
      '(("home"
	 ("Emacs Config" (filename . ".emacs.d"))
         ("Workspace" (filename . "workspace"))
         ("Terminals" (mode . term-mode))
	 ("Org" (mode . org-mode))
	 ("IRC" (mode . rcirc-mode))
	 ("Help" (or (name . "\*Help\*")
		     (name . "\*Apropos\*")
		     (name . "\*info\*"))))))

(add-hook 'ibuffer-mode-hook 
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     (ibuffer-switch-to-saved-filter-groups "home")))


; Enable ibuffer-filter-by-filename to filter on directory names too.
(eval-after-load "ibuf-ext"
  '(define-ibuffer-filter filename
     "Toggle current view to buffers with file or directory name matching QUALIFIER."
     (:description "filename"
                   :reader (read-from-minibuffer "Filter by file/directory name (regexp): "))
     (ibuffer-awhen (or (buffer-local-value 'buffer-file-name buf)
                        (buffer-local-value 'dired-directory buf))
                    (string-match qualifier it))))


(require 'volatile-highlights)
(volatile-highlights-mode 1)

(global-auto-revert-mode 1) ; Auto reload buffers when modified externally
