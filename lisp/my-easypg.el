(require 'epa)

(setq password-cache-expiry nil)

(defun gpg-read-file (file)
  (let ((decrypt-file (expand-file-name file user-emacs-directory))
	(ctx (epg-make-context epa-protocol)))
    (if (not (file-exists-p decrypt-file))
	(error "File %s does not exist" decrypt-file)
      (epg-decrypt-file ctx decrypt-file nil))))
