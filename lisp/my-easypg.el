(require 'pinentry)
(require 'epa)

(defvar have-private-key
  (string= (shell-command-to-string "gpg --list-secret-keys | grep 720FD288FB5BBF5DE3A4BEBA92C6AB6D6C229F93 | wc -l") "1\n"))

(defvar gpg-agent-ssh-sock
  (concat "/run/user/" (number-to-string (user-uid)) "/gnupg/S.gpg-agent.ssh"))

(defun read-gpg-file (file)
  (let ((file-to-decrypt (expand-file-name file user-emacs-directory))
	(ctx (epg-make-context epa-protocol)))
    (if (file-exists-p file-to-decrypt)
	(epg-decrypt-file ctx file-to-decrypt nil)
      (message "Decrypting %s...failed" file-to-decrypt)
      (error "File %s does not exist" file-to-decrypt))))

(defun load-gpg (file)
  (if have-private-key
      (load file)
    (message "WARNING: Couldn't load %s (No gpg key found)" file)))


(defun epa-progress-callback-function (_context what _char current total handback) nil)

; load this in a post-frame hook because gpg-agent asks for a password on first
; startup and caches it. Don't want emacs daemon to hang because of gpg-agent.
(defun load-private-data ()
  (interactive)
  (if (not have-private-key)
      (message "ERROR: Private GPG key not found")
    (start-process "gpg-agent" nil "gpg-agent" "--daemon")
    (setenv "SSH_AUTH_SOCK" gpg-agent-ssh-sock)
    (setq password-cache-expiry nil
	  pinentry--socket-dir temporary-file-directory)
    (unless (file-exists-p (concat pinentry--socket-dir "pinentry"))
      (pinentry-start)
      (add-hook 'kill-emacs-hook 'pinentry-stop))
    (add-to-list 'load-suffixes ".el.gpg")
    (load-gpg "private-config")
    (when (get-buffer "*Pinentry*")
      (kill-buffer "*Pinentry*"))))

(defun first-frame-hook (frame)
  (remove-hook 'after-make-frame-functions 'first-frame-hook)
  (run-at-time nil nil 'load-private-data))

(add-hook 'after-make-frame-functions 'first-frame-hook)
