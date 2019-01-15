(require 'battery)
(require 'time)

(setq-default mode-line-format nil)

(setq-default mode-line-buffer-identification
	      (list 'buffer-file-name
		    (propertized-buffer-identification "%12f")
		    (propertized-buffer-identification "%12b")))

(defun mode-line-dirtrack ()
  (setq mode-line-buffer-identification
	'(:eval (propertized-buffer-identification default-directory))))

(add-hook 'dired-mode-hook 'mode-line-dirtrack)
(add-hook 'shell-mode-hook 'mode-line-dirtrack)
(add-hook 'term-mode-hook  'mode-line-dirtrack)

(defun mode-line-fill (end-space)
  (propertize " " 'display `((space :align-to (- right 1 ,end-space)))))

(defcustom minibuffer-line-format
  '(""
    mode-line-modified
    " (%l,%c) %p/%I  "
    mode-line-buffer-identification
    " "
    (:eval (mode-line-fill (+ (length battery-mode-line-string) 1
			      (length display-time-string))))
    display-time-string
    " "
    battery-mode-line-string)
  "Specification of the contents of the minibuffer-line.
Uses the same format as `mode-line-format'."
  :type 'sexp)

(defun minibuffer-line--update ()
  (with-current-buffer " *Minibuf-0*"
    (erase-buffer)
    (insert (format-mode-line minibuffer-line-format 'mode-line))))

(setq battery-mode-line-string "no battery")
(when battery-status-function
  (setq battery-mode-line-format "%L %p%% %t")
  (battery-update))

(setq display-time-format "%a %H:%M")
(display-time-update)

(defun minibuffer-line--timer-update ()
  (when battery-status-function (battery-update))
  (display-time-update)
  (minibuffer-line--update))

(setq minibuffer-line--timer
      (run-with-timer t 30 #'minibuffer-line--timer-update))
