(require 'battery)

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
    (:eval (mode-line-fill (length battery-mode-line-string)))
    battery-mode-line-string)
  "Specification of the contents of the minibuffer-line.
Uses the same format as `mode-line-format'."
  :type 'sexp)

(defun minibuffer-line--update ()
  (with-current-buffer " *Minibuf-0*"
    (erase-buffer)
    (insert (format-mode-line minibuffer-line-format 'mode-line))))

(setq battery-mode-line-string "[no battery]")

(when battery-status-function
  (defun minibuffer-line--bat-update ()
    (battery-update)
    (minibuffer-line--update))
  (setq battery-mode-line-format "[%L %p%% %t]"
	minibuffer-line--timer (run-with-timer t 15 #'minibuffer-line--bat-update))
  (battery-update))
