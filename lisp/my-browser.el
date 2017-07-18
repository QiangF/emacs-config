(when (and (require 'atomic-chrome nil t) (daemonp))
  (atomic-chrome-start-server))
