(require 'ibuffer)
(require 'ibuffer-vc)

(defalias 'list-buffers 'ibuffer)

(setq ibuffer-expert t)
(setq ibuffer-show-empty-filter-groups nil)

(setq ibuffer-saved-filter-groups
      '(("home"
         ("Terminals" (mode . term-mode))
	 ("Org" (mode . org-mode))
	 ("Help" (or (name . "\*Help\*")
		     (name . "\*Apropos\*")
		     (name . "\*info\*"))))))

(setq ibuffer-formats
      '((mark modified read-only vc-status-mini " "
	      (name 18 18 :left :elide)
              " "
              (size-h -1 -1)
              " "
              (mode 12 12 :left :elide)
              " "
              filename-and-process)))

(add-hook 'ibuffer-hook
          (lambda () (ibuffer-auto-mode 1)))

(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (ibuffer-do-sort-by-alphabetic)))

; human readable size column
(eval-after-load 'ibuffer
  '(progn
     (define-ibuffer-column size-h
       (:name "Size" :inline t)
       (cond
        ((> (buffer-size) 1000000) (format "%3.1fM" (/ (buffer-size) 1048576)))
        ((> (buffer-size) 1000) (format "%3.1fK" (/ (buffer-size) 1024)))
        (t (format "%4d" (buffer-size)))))))
