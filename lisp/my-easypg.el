(require 'epa)

(setq password-cache-expiry nil)

(defvar have-private-key
  (string= (shell-command-to-string "gpg --list-secret-keys | grep 720FD288FB5BBF5DE3A4BEBA92C6AB6D6C229F93 | wc -l") "1\n"))

(when have-private-key
  (add-to-list 'load-suffixes ".el.gpg"))

(defun read-gpg-file (file)
  (let ((decrypt-file (expand-file-name file user-emacs-directory))
	(ctx (epg-make-context epa-protocol)))
    (if (not (file-exists-p decrypt-file))
	(error "File %s does not exist" decrypt-file)
      (epg-decrypt-file ctx decrypt-file nil))))

(defun load-gpg (file)
  (if have-private-key (load file)
    (message "Couldn't load %s: No gpg key found" file)))
