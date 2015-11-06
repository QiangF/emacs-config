(require 'gnus)

;(setq gnus-startup-file (expand-file-name ".emacs.d/.newsrc")
;      gnus-init-file nil
;      gnus-read-newsrc-file nil)

;(setq gnus-select-method '(nntp "news.gmane.org"))

;(setq gnus-read-active-file 'some)

;(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

;(setq gnus-summary-thread-gathering-function
;      'gnus-gather-threads-by-subject)

;(setq gnus-thread-hide-subtree t)
;(setq gnus-thread-ignore-subject t)

;(setq mm-discouraged-alternatives '("text/html" "text/richtext"))

(setq gnus-select-method
      '(nnmaildir "GMail"
                  (directory "~/Mail/Gmail/")
                  (directory-files nnheader-directory-files-safe)
                  (get-new-mail nil)))
