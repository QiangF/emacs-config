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

(eval-after-load 'ibuffer
  '(progn
     ;; Use human readable Size column instead of original one
     (define-ibuffer-column size-h
       (:name "Size" :inline t)
       (cond
        ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1048576)))
        ((> (buffer-size) 1000) (format "%7.1fK" (/ (buffer-size) 1024)))
        (t (format "%8d" (buffer-size)))))))

;; Modify the default ibuffer-formats
(setq ibuffer-formats
      '((mark modified read-only " "
              (name 18 18 :left :elide)
              " "
              (size-h 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " "
              filename-and-process)))
