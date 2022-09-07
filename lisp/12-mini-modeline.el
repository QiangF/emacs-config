(require 'mini-modeline)
(require 'battery)
(require 'cl-seq)

(defun symon-linux--read-lines (file reader indices)
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char 1)
    (mapcar (lambda (index)
              (save-excursion
                (when (search-forward-regexp (concat "^" index "\\(.*\\)$") nil t)
                  (if reader
                      (funcall reader (match-string 1))
                    (match-string 1)))))
            indices)))

(defvar symon-linux--last-cpu-ticks nil)
(defvar sysmon-modeline-string nil)
(defvar sysmon-update-interval 2)
(defvar sysmon-update-timer nil)
(defvar symon-refresh-rate 4)
(defvar symon-linux--last-network-rx 0)
(defvar symon-linux--last-network-tx 0)

(define-minor-mode sysmon-display-mode
  "Toggle system monitor display in mode line

The mode line is be updated every `sysmon-update-interval' seconds."
  :global t
  (if sysmon-update-timer
      (progn
	(cancel-timer sysmon-update-timer)
	(setq sysmon-update-timer nil)
	(setq sysmon-modeline-string nil))
    (setq sysmon-update-timer (run-at-time nil sysmon-update-interval
                                            #'sysmon-update))
    (sysmon-update)
    (redisplay)))

(defun sysmon-update ()
  "Update cpu status information in the mode line."
  (setq sysmon-modeline-string
	(concat
	 ;; cpu usage
	 (format "c:%s%%%% rx:%s tx:%s m:%s%%%%%s"
		 ;; cpu usage
		 (cl-destructuring-bind (cpu)
		     (symon-linux--read-lines
		      "/proc/stat" (lambda (str) (mapcar 'read (split-string str nil t))) '("cpu"))
		   (let ((total (apply '+ cpu)) (idle (nth 3 cpu)))
		     (prog1 (when symon-linux--last-cpu-ticks
			      (let ((total-diff (- total (car symon-linux--last-cpu-ticks)))
				    (idle-diff (- idle (cdr symon-linux--last-cpu-ticks))))
				(unless (zerop total-diff)
				  (/ (* (- total-diff idle-diff) 100) total-diff))))
		       (setq symon-linux--last-cpu-ticks (cons total idle)))))
		 ;; Receive speed in kb
		 (with-temp-buffer
		   (insert-file-contents "/proc/net/dev")
		   (goto-char 1)
		   (let ((rx 0) the-str)
		     (while (search-forward-regexp "^[\s\t]*\\(.*\\):" nil t)
		       (unless (string= (match-string 1) "lo")
			 (setq rx (+ rx (read (current-buffer))))))
		     ;; warn the user if rx > 2000 kb/s
		     ;; (setq the-str (if (> (/ (- rx symon-linux--last-network-rx) symon-refresh-rate 1000) 2000) "R!!" ""))
		     (prog1 (when symon-linux--last-network-rx
			      (/ (- rx symon-linux--last-network-rx) symon-refresh-rate 1000))
		       (setq symon-linux--last-network-rx rx))))
		 ;; Transmit speed
		 (with-temp-buffer
		   (insert-file-contents "/proc/net/dev")
		   (goto-char 1)
		   (let ((tx 0) the-str)
		     (while (search-forward-regexp "^[\s\t]*\\(.*\\):" nil t)
		       (unless (string= (match-string 1) "lo")
			 (forward-word 8)
			 (setq tx (+ tx (read (current-buffer))))))
		     ;; warn the user if tx > 500 kb/s
		     ;;(setq the-str (if (> (/ (- tx symon-linux--last-network-tx) symon-refresh-rate 1000) 500) "T!!" ""))
		     (prog1 (when symon-linux--last-network-tx
			      (/ (- tx symon-linux--last-network-tx) symon-refresh-rate 1000))
		       (setq symon-linux--last-network-tx tx))))
		 ;; memory
		 (cl-destructuring-bind (memtotal memavailable memfree buffers cached)
		     (symon-linux--read-lines
		      "/proc/meminfo" (lambda (str) (and str (read str)))
		      '("MemTotal:" "MemAvailable:" "MemFree:" "Buffers:" "Cached:"))
		   (if memavailable
		       (/ (* (- memtotal memavailable) 100) memtotal)
		     (/ (* (- memtotal (+ memfree buffers cached)) 100) memtotal)))
		 ;; swapped
		 (cl-destructuring-bind (swaptotal swapfree)
		     (symon-linux--read-lines
		      "/proc/meminfo" 'read '("SwapTotal:" "SwapFree:"))
		   (let ((swapped (/ (- swaptotal swapfree) 1000)))
		     (if (zerop swapped)
			 ""
		       (format " %dMB Swapped" swapped))))))))

(setq mini-modeline-right-padding 0)
(setq mini-modeline-truncate-p nil)
(setq display-time-day-and-date nil)
(setq mini-modeline-echo-duration 2)
(display-time-mode t)

(defun mini-modeline-msg ()
  "Place holder to display echo area message."
  (let ((max-string-length 5000))
    (if (> (length mini-modeline--msg) max-string-length)
        (concat (substring mini-modeline--msg 0 (floor max-string-length 2))
                "\n ...... \n"
                (substring mini-modeline--msg-message (floor max-string-length -2)))
      mini-modeline--msg)))

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
                      tag
                    (when num (int-to-string num)))))
        (when str
          (setq workspace-str (concat workspace-str (format ":%s" str))))))
    (when (and (bound-and-true-p persp-mode)
               (< 1 (length (hash-table-values (perspectives-hash)))))
      (setq workspace-str (concat workspace-str
				  (propertize (format ":%s" (persp-current-name)) 'face '((:background "#004040" :foreground "#ff0000"))))))
    workspace-str))

(setq god-local-mode nil)
(setq display-time-24hr-format t)
(setq display-time-mail-string "")

(set-face-attribute 'mode-line-buffer-id nil :foreground "red")

(setq resize-mini-windows nil
      resize-mini-frames nil)

(defvar my-modeline-background "black")

(setq mini-modeline-r-format '("%e" mode-line-process
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

(setq redisplay-dont-pause nil)

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
