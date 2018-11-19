(setq org-babel-temporary-directory (concat temporary-file-directory "babel"))

(unless (file-directory-p org-babel-temporary-directory)
  (dired-create-directory org-babel-temporary-directory))

(setq org-agenda-files (file-expand-wildcards "~/org/*.org"))

(global-set-key "\C-ca" 'org-agenda)
