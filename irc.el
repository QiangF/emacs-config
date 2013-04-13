(require 'rcirc)

(setq rcirc-default-user-name "adirat"
      rcirc-default-full-name "Adi Ratiu"
      rcirc-default-nick "air00")

(setq rcirc-authinfo
      '(("freenode" nickserv "user" "pass")
        ("localhost" bitlbee "user" "pass")))

(setq rcirc-server-alist
      '(("irc.freenode.net" :channels ("#archlinux"))
        ("localhost" :channels ("#bitlbee"))))

(setq rcirc-omit-responses '("JOIN" "PART" "QUIT" "NICK" "AWAY"))

(add-hook 'rcirc-mode-hook
          (lambda ()
            ; keep input line at bottom
            (set (make-local-variable 'scroll-conservatively) 8192)
            (rcirc-omit-mode)
            (rcirc-track-minor-mode 1))) ; show IRC updates

(require 'rcirc-notify-mode)
(setq rcirc-notify-mode:buffer-name "*notifications*")
