(require 'tramp-cache)

(setq tramp-persistency-file-name
      (concat temporary-file-directory "tramp"))

(setq tramp-default-method "ssh")
