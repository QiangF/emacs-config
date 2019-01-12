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

(setq-default mode-line-end-spaces
      (propertize " " 'display '(space :align-to right)))

(defcustom minibuffer-line-format
  '(""
    mode-line-modified
    " (%l,%c) %p/%I  "
    mode-line-buffer-identification
    mode-line-end-spaces)
  "Specification of the contents of the minibuffer-line.
Uses the same format as `mode-line-format'."
  :type 'sexp)

(defvar minibuffer-line--timer nil)

(defun minibuffer-line--update ()
  (with-current-buffer " *Minibuf-0*"
    (erase-buffer)
    (insert (format-mode-line minibuffer-line-format 'mode-line))))
