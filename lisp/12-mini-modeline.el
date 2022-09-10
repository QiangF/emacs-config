(require 'mini-modeline)
(require 'battery)

(defvar sysmon-modeline-string nil)

(defun sysmon-modeline-filter-fun (process output)
  (let ((stokens (split-string output split-string-default-separators)))
    (setq sysmon-modeline-string
	  (format "u:%-4ss:%-4srx:%-5stx:%-5sdw:%-5sdr:%-5suse:%-6sfre:%-3sbuf:%-5scac:%-3sswp:%s/%-2s"
	   (car stokens) ;usr
	   (cadr stokens) ;sys
	   (caddr stokens) ;rx
	   (cadddr stokens) ;tx
	   (car (nthcdr 5 stokens)) ;dr
	   (car (nthcdr 4 stokens)) ;dw
	   (car (nthcdr 8 stokens)) ;mem used
	   (car (nthcdr 9 stokens)) ;mem free
	   (car (nthcdr 10 stokens)) ;mem buf
	   (car (nthcdr 11 stokens)) ;mem cach
	   (car (nthcdr 6 stokens)) ;swp used
	   (car (nthcdr 7 stokens)) ;swp avail
	   ))))

(setq dool-proc nil)

(define-minor-mode sysmon-display-mode
  "Toggle system monitor display in mode line"
  :global t
  (if dool-proc
      (progn
	(kill-process dool-proc)
	(setq dool-proc nil
	      sysmon-modeline-string nil))
    (setq dool-proc
      (start-process
       "dool-proc" nil
       "/home/adi/workspace/dool/dool"
       "-cndsm" "--nocolor" "--noheaders"
       "--output" "/dev/null"))
    (set-process-filter dool-proc 'sysmon-modeline-filter-fun)))

(setq mini-modeline-right-padding 0)
(setq mini-modeline-truncate-p t)
(setq display-time-day-and-date nil)
(setq mini-modeline-echo-duration 2)
(display-time-mode t)

(setq battery-mode-line-string nil
      battery-mode-line-format "B%b%p")

(when (battery--find-linux-sysfs-batteries)
    (display-battery-mode 1))

(defun awesome-tray-module-workspace-info ()
  (let ((workspace-str ""))
    (when (boundp 'exwm-workspace-current-index)
      (setq workspace-str
            (concat workspace-str
                    (propertize (int-to-string exwm-workspace-current-index) 'face '((:background "#0000ff" :foreground "#ffff00"))))))
    (when (and (bound-and-true-p eyebrowse-mode)
               (< 1 (length (eyebrowse--get 'window-configs))))
      (let* ((num (eyebrowse--get 'current-slot))
             (tag (when num (nth 2 (assoc num (eyebrowse--get 'window-configs)))))
             (str (if (and tag (< 0 (length tag)))
                      tagGG
                    (when num (int-to-string num)))))
        (when str
          (setq workspace-str (concat workspace-str (format ":%s" str))))))
    (when (and (bound-and-true-p persp-mode)
               (< 1 (length (hash-table-values (perspectives-hash)))))
      (setq workspace-str (concat workspace-str
				  (propertize (format ":%s" (persp-current-name)) 'face '((:background "#004040" :foreground "#ff0000"))))))
    workspace-str))

(setq display-time-24hr-format t)
(setq display-time-mail-string "")

(set-face-attribute 'mode-line-buffer-id nil :foreground "red")

(setq resize-mini-windows nil
      resize-mini-frames nil)

(defvar my-modeline-background "black")

(setq mini-modeline-r-format '("%e"
			       " "
			       mode-line-position
			       mode-line-remote
			       mode-line-mule-info
			       mode-line-modified
			       (:eval (when sysmon-modeline-string
					   (concat
					    " "
					    (propertize
					     sysmon-modeline-string
					     'face `((:foreground "plum3" :background ,my-modeline-background)))
					    )))
			       " "
			       (:eval (propertize (format-time-string "%H:%M")
						  'face `((:foreground "green" :background ,my-modeline-background))))
                               (:eval (when battery-mode-line-string
                                        (concat
                                         " "
                                         (propertize
                                          battery-mode-line-string
                                          'face `((:foreground "plum3" :background ,my-modeline-background))))))
			       " "
			       (:eval (awesome-tray-module-workspace-info)
				      'face `((:background ,my-modeline-background)))))

(setq max-mini-window-height 1)

(defun my-command-error-function (data context caller)
  "Ignore the buffer-read-only, beginning-of-buffer,
end-of-buffer signals; pass the rest to the default handler."
  (when (not (memq (car data) '(buffer-read-only
                                beginning-of-buffer
                                end-of-buffer
				quit)))
    (command-error-default-function data context caller)))

(setq command-error-function #'my-command-error-function)

(add-hook 'before-make-frame-hook 'mini-modeline-mode)

(sysmon-display-mode)
