(require 'epa)

(setq password-cache-expiry nil
      epa-pinentry-mode 'loopback)

(setenv "SSH_AUTH_SOCK"
	(concat "/run/user/" (number-to-string (user-uid)) "/gnupg/S.gpg-agent.ssh"))

(defun epa-progress-callback-function (_context what _char current total handback) nil)

(defun load-private-data ()
  (when (= 0 (call-process "ssh" nil nil nil "-q" "mailstore-server" ":"))
    (load "99-mail-config")
    (advice-remove 'notmuch-hello #'load-private-data)))

(advice-add 'notmuch-hello :before #'load-private-data)
