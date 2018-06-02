(require 'epa)

(setq password-cache-expiry nil
      epa-pinentry-mode 'loopback)

(add-to-list 'load-suffixes ".el.gpg")

(setenv "SSH_AUTH_SOCK"
	(concat "/run/user/" (number-to-string (user-uid)) "/gnupg/S.gpg-agent.ssh"))

(defun epa-progress-callback-function (_context what _char current total handback) nil)
