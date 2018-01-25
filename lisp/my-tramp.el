(require 'tramp-cache)

(setq tramp-persistency-file-name (concat temporary-file-directory "tramp-persistency")
      tramp-histfile-override (concat temporary-file-directory "tramp-history"))

(setq tramp-default-method "ssh")
