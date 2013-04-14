(require 'rcirc)
(require 'rcirc-notify-mode)

(add-hook 'rcirc-mode-hook 'rcirc-omit-mode)
(add-hook 'rcirc-mode-hook 'rcirc-track-minor-mode)

(setq rcirc-omit-responses '("JOIN" "PART" "QUIT" "NICK" "AWAY")
      rcirc-notify-mode:buffer-name "*notifications*"
      rcirc-keywords '("air00")
      rcirc-fill-column 80
      rcirc-server-alist nil

      rcirc-default-user-name "adirat"
      rcirc-default-full-name "Adi Ratiu"
      rcirc-default-nick "air00")

(setq rcirc-authinfo
      '(("freenode" nickserv "user" "pass")
        ("localhost" bitlbee "user" "pass")))

(add-to-list 'rcirc-server-alist
             '("irc.freenode.net"
               :channels ("#archlinux"
                          "#haskell"
                          "#emacs")))

(add-to-list 'rcirc-server-alist
             '("localhost"
               :channels ("#bitlbee")))
