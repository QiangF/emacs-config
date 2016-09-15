(require 'pinentry)

(unless (file-exists-p (concat pinentry--socket-dir "/pinentry"))
  (message "Starting pinentry daemon")
  (pinentry-start))

(add-hook 'kill-emacs-hook 'pinentry-stop)