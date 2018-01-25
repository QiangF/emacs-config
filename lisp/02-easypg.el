(require 'epa)

(start-process "gpg-agent" nil "gpg-agent" "--daemon")

(setenv "SSH_AUTH_SOCK"
	(concat "/run/user/" (number-to-string (user-uid)) "/gnupg/S.gpg-agent.ssh"))

(setq password-cache-expiry nil)

(setq epa-pinentry-mode 'loopback)

(defvar have-private-key
  (string= (shell-command-to-string "gpg --list-secret-keys | grep 720FD288FB5BBF5DE3A4BEBA92C6AB6D6C229F93 | wc -l") "1\n"))

(defun read-gpg-file (file)
  (let ((file-to-decrypt (expand-file-name file user-emacs-directory))
	(ctx (epg-make-context epa-protocol)))
    (if (file-exists-p file-to-decrypt)
	(epg-decrypt-file ctx file-to-decrypt nil)
      (message "Decrypting %s...failed" file-to-decrypt)
      (error "File %s does not exist" file-to-decrypt))))

(defun epa-progress-callback-function (_context what _char current total handback) nil)

; load this in a post-frame hook because gpg-agent asks for a password on first
; startup and caches it. Don't want emacs daemon to hang because of no gpg-agent.
(defun load-private-data ()
  (interactive)
  (if (not have-private-key)
      (message "ERROR: Private GPG key not found")
    (add-to-list 'load-suffixes ".el.gpg")
    (load "99-private-config")))

(defun first-frame-hook (frame)
  (remove-hook 'after-make-frame-functions 'first-frame-hook)
  (run-at-time nil nil 'load-private-data))

(add-hook 'after-make-frame-functions 'first-frame-hook)
