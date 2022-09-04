(when (string= system-name "iwork")
  (require 'exwm)
  (require 'exwm-config)

  (add-to-list 'undo-tree-incompatible-major-modes 'exwm-mode)

  ;;(require 'exwm-systemtray)
  ;;(exwm-systemtray-enable)

  ;; Fix problems with Ido (if you use it).
  (exwm-config-ido)
  (exwm-config-default)

  ;; Set the initial number of workspaces (they can also be created later).
  (setq exwm-workspace-number 10)

  (defun my/exwm--format-window-title-firefox (title &optional length)
    "Removes noise from and trims Firefox window titles.
     Assumes the Add URL to Window Title extension is enabled and
     configured to use @ (at symbol) as separator."
    (let* ((length (or length 45))
           (title (concat "F# " (replace-regexp-in-string " [-—] Mozilla Firefox$" "" title)))
           (title-and-hostname (split-string title "@" nil " "))
           (hostname (substring (car (last title-and-hostname)) 0 -1))
           (page-title (string-join (reverse (nthcdr 1 (reverse title-and-hostname))) " "))
           (short-title (reverse (string-truncate-left (reverse page-title) length))))
      (if (length> title-and-hostname 1)
          (concat short-title " @ " hostname)
	(reverse (string-truncate-left (reverse title) length)))))


  (defun my/exwm--format-window-title-* (title)
    "Removes annoying notifications counters."
    (string-trim (replace-regexp-in-string "([[:digit:]]+)" "" title)))

  (defun my/exwm-buffer-name ()
    "Guesses (and formats) the buffer name using the class of the X client."
    (let ((title (my/exwm--format-window-title-* exwm-title))
          (formatter (intern
                      (format "my/exwm--format-window-title-%s"
                              (downcase exwm-class-name)))))
      (if (fboundp formatter)
          (funcall formatter title)
	title)))

  (add-hook 'exwm-update-title-hook
            (lambda ()
              (exwm-workspace-rename-buffer (my/exwm-buffer-name))))

  (setq exwm-manage-configurations '((t char-mode t)))
)
