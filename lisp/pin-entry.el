(require 'pinentry)

(if (not (file-exists-p (concat pinentry--socket-dir "/pinentry")))
    (pinentry-start))

(add-hook 'kill-emacs-hook 'pinentry-stop)
