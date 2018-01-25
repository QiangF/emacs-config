(setq org-babel-temporary-directory (concat temporary-file-directory "babel"))

(unless (file-directory-p org-babel-temporary-directory)
  (dired-create-directory org-babel-temporary-directory))

(require 'org)
