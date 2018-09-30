(setq org-babel-temporary-directory (concat temporary-file-directory "babel"))

(unless (file-directory-p org-babel-temporary-directory)
  (dired-create-directory org-babel-temporary-directory))

(require 'org)

(setq org-agenda-files (file-expand-wildcards (concat user-emacs-directory "org/*.org.gpg"))
      org-agenda-file-regexp "\\`[^.].*\\.org.gpg\\'")
