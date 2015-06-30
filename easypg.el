(require 'epa)

; (setenv “GPG_AGENT_INFO” nil)
;(epa-file-enable)

(add-to-list 'load-suffixes ".gpg")

(defun load-my-config ()
  (interactive)
  (unless (member 'my-config features)
    (load-user-file "my-config.gpg")))

(setq password-cache-expiry nil)
