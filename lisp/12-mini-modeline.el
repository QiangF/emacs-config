(require 'mini-modeline)
(require 'battery)
(require 'cl-seq)

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

(defvar symon-refresh-rate 4)
(defvar symon-linux--last-network-rx 0)
(defvar symon-linux--last-network-tx 0)
(defvar my-last-symon-message "")

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

;; (defun my-update-symon ()
;;   (setq my-last-symon-message
;;         (concat
;;          ;; Receive speed in kb
;;          (with-temp-buffer
;;            (insert-file-contents "/proc/net/dev")
;;            (goto-char 1)
;;            (let ((rx 0) the-str)
;;              (while (search-forward-regexp "^[\s\t]*\\(.*\\):" nil t)
;;                (unless (string= (match-string 1) "lo")
;;                  (setq rx (+ rx (read (current-buffer))))))
;;              ;; warn the user if rx > 2000 kb/s
;;              (setq the-str (if (> (/ (- rx symon-linux--last-network-rx) symon-refresh-rate 1000) 2000) "R!!" ""))
;;              (setq symon-linux--last-network-rx rx)
;;              the-str))
;;          ;; Transmit speed
;;          (with-temp-buffer
;;            (insert-file-contents "/proc/net/dev")
;;            (goto-char 1)
;;            (let ((tx 0) the-str)
;;              (while (search-forward-regexp "^[\s\t]*\\(.*\\):" nil t)
;;                (unless (string= (match-string 1) "lo")
;;                  (forward-word 8)
;;                  (setq tx (+ tx (read (current-buffer))))))
;;              ;; warn the user if tx > 500 kb/s
;;              (setq the-str (if (> (/ (- tx symon-linux--last-network-tx) symon-refresh-rate 1000) 500) "T!!" ""))
;;              (setq symon-linux--last-network-tx tx)
;;              the-str))
;;          ;; memory
;;          (format "M:%s"
;;                  (cl-destructuring-bind (memtotal memavailable memfree buffers cached)
;;                      (symon-linux--read-lines
;;                       "/proc/meminfo" (lambda (str) (and str (read str)))
;;                       '("MemTotal:" "MemAvailable:" "MemFree:" "Buffers:" "Cached:"))
;;                    (if memavailable
;;                        (/ (* (- memtotal memavailable) 100) memtotal)
;;                        (/ (* (- memtotal (+ memfree buffers cached)) 100) memtotal))))
;;          ;; swapped
;;          (cl-destructuring-bind (swaptotal swapfree)
;;              (symon-linux--read-lines
;;               "/proc/meminfo" 'read '("SwapTotal:" "SwapFree:"))
;;            (let ((swapped (/ (- swaptotal swapfree) 1000)))
;;              (unless (zerop swapped) (format " %dMB Swapped" swapped)))))))

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

;; (setq toki-tabs-visible-buffer-limit 4)

;; (defface toki-modeline-path-face
;;   '((((background light))
;;      :foreground "#ff0000" :italic t)
;;     (t
;;      :foreground "#ff0000" :italic t))
;;   "Face for file path.")

;; (defun toki-modeline-tabs ()
;;   "Return tabs."
;;   (if (bound-and-true-p toki-tabs-mode)
;;       (toki-tabs-string)
;;     ""))

;; (setq mini-modeline-l-format '((:eval (toki-modeline-tabs))))

;; (defun my-echo-tabs ()
;;   (let ((mini-modeline--msg nil)
;;         (mini-modeline--msg-message nil))
;;     (when (timerp mini-modeline--timer) (cancel-timer mini-modeline--timer))
;;     (mini-modeline-display 'force)
;;     (setq mini-modeline--timer
;;           (run-with-timer mini-modeline-echo-duration 1 #'mini-modeline-display 'force))))

;; (add-hook 'toki-tabs-update-hook 'my-echo-tabs)

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
