(require 'gnus)

(setq gnus-startup-file (expand-file-name ".emacs.d/.newsrc")
      gnus-init-file nil
      gnus-read-newsrc-file nil)

(setq user-full-name "Ioan-Adrian Rațiu")
(setq user-mail-address "adi@adirat.com")

(setq gnus-select-method '(nntp "news.gmane.org"))

(add-to-list 'gnus-secondary-select-methods
	     '(nnmaildir "adiratcom" (directory "~/Documents/Mail/adiratcom/") (get-new-mail nil)))

(setq mail-sources '((maildir :path "~/Documents/Mail/adiratcom/" :subdirs ("cur" "new")))
      mail-source-delete-incoming t)

(setq gnus-read-active-file 'some)

(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

(setq gnus-summary-thread-gathering-function 
      'gnus-gather-threads-by-subject)

;(setq gnus-thread-hide-subtree t)
(setq gnus-thread-ignore-subject t)

(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      message-signature "Ioan-Adrian Rațiu"
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587
				   "adi@adirat.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-local-domain "adirat.com"
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

(setq mm-discouraged-alternatives '("text/html" "text/richtext"))
