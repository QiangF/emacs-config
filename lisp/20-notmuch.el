; -*- lexical-binding: t -*-
(require 'notmuch)
(require 'notmuch-wash)

(setq notmuch-show-logo nil
      notmuch-always-prompt-for-sender t
      notmuch-hello-thousands-separator ""
      notmuch-show-empty-saved-searches t
      notmuch-show-all-tags-list t
      notmuch-show-insert-filesize t
      notmuch-crypto-process-mime t
      notmuch-wash-wrap-lines-length nil)

(setq notmuch-hello-sections
      '(notmuch-hello-insert-saved-searches
	notmuch-hello-insert-search
	notmuch-hello-insert-recent-searches))

(global-set-key (kbd "C-x m") 'notmuch-mua-new-mail)

(setq message-send-mail-function 'message-smtpmail-send-it
      send-mail-function 'smtpmail-send-it
      smtpmail-debug-info t
      message-kill-buffer-on-exit t
      message-use-idna nil
      message-sendmail-envelope-from 'header
      message-auto-save-directory nil
      mail-user-agent 'notmuch-user-agent
      notmuch-message-replied-tags nil
      notmuch-address-command 'internal)

(defun setTlsConfig ()
  (interactive)
  (setq smtpmail-stream-type 'starttls
	starttls-extra-arguments nil
	starttls-gnutls-program "/usr/bin/gnutls-cli"
	starttls-use-gnutls t))

(defun set-smtp-server ()
  (interactive)
  (if (message-mail-p)
      (save-excursion
	(let* ((from (or (save-restriction
			  (message-narrow-to-headers)
			  (message-fetch-field "from")) ""))
	       (set-smtp-fun (cadr (assoc from iden-smtp-servers))))
	  (funcall set-smtp-fun)))))

(add-hook 'message-send-mail-hook 'set-smtp-server)

(setq-default notmuch-search-oldest-first nil)

(define-key notmuch-hello-mode-map "g" 'notmuch-refresh-this-buffer)
(define-key notmuch-search-mode-map "g" 'notmuch-refresh-this-buffer)

(define-key notmuch-show-mode-map "r" (lambda () (interactive) (notmuch-show-reply t)))
(define-key notmuch-show-mode-map "R" 'notmuch-show-reply-sender)

(define-key notmuch-hello-mode-map "a" 'widget-button-press)
(define-key notmuch-search-mode-map "a" 'notmuch-search-show-thread)
(define-key notmuch-show-mode-map "a" nil)

(setq message-citation-line-format "On %a, %d %b %Y, %f wrote:")
(setq message-citation-line-function 'message-insert-formatted-citation-line)

(setq notmuch-show-insert-text/plain-hook
      '(notmuch-wash-convert-inline-patch-to-part
       notmuch-wash-excerpt-citations))

(defun nm-add-show-key-toggle (key tag)
  "add toggle tag for notmuch-show selected message"
  (define-key notmuch-show-mode-map key
    (lambda ()
      (interactive)
      (if (member tag (notmuch-show-get-tags))
	  (notmuch-show-tag (list (concat "-" tag)))
	(notmuch-show-tag (list (concat "+" tag)))))))

(defun nm-add-search-key-toggle (key tag)
  "add toggle tag for notmuch-search messages"
  (define-key notmuch-search-mode-map key
    (lambda (&optional beg end)
      (interactive (notmuch-search-interactive-region))
      (if (member tag (notmuch-search-get-tags))
	  (notmuch-search-tag (list (concat "-" tag)) beg end)
	(notmuch-search-tag (list (concat "+" tag)) beg end)))))

(nm-add-show-key-toggle "d" "deleted")
(nm-add-search-key-toggle "d" "deleted")
(nm-add-show-key-toggle "u" "unread")
(nm-add-search-key-toggle "u" "unread")

(defun notmuch-hello-insert-saved-searches ()
  "Insert the saved-searches section."
  (let ((searches (notmuch-hello-query-counts
		   (if notmuch-saved-search-sort-function
		       (funcall notmuch-saved-search-sort-function
				notmuch-saved-searches)
		     notmuch-saved-searches)
		   :show-empty-searches notmuch-show-empty-saved-searches)))
    (when searches
      (widget-insert "\n")
      (let ((start (point)))
	(notmuch-hello-insert-buttons searches)
	(indent-rigidly start (point) notmuch-hello-indent)))))

; enable address auto-complation
(setq notmuch-address-selection-function
      (lambda (prompt collection initial-input)
        (completing-read prompt (cons initial-input collection) nil t nil 'notmuch-address-history)))

(setq notmuch-command (executable-find "notmuch"))
(unless notmuch-command
  (setq notmuch-command "notmuch-remote"))

(defun my-message-current-line-cited-p ()
  "Indicate whether the line at point is a cited line."
  (save-match-data
    (string-match (concat "^" message-cite-prefix-regexp)
                  (buffer-substring (line-beginning-position) (line-end-position)))))

(setq notmuch-hello-auto-refresh nil)

(setq notmuch-search-result-format '(("date" . "%12s ")
				     ("filesize" . "%6s ")
				     ("count" . "%-7s ")
				     ("authors" . "%-20s ")
				     ("subject" . "%s ")
				     ("tags" . "(%s)")))

(defun load-mail-config (&rest args)
  (unless (boundp 'iden-smtp-servers)
    (load "99-mail-config")
    (advice-remove 'notmuch-hello 'load-mail-config)))

(advice-add 'notmuch-hello :before 'load-mail-config)
(advice-add 'notmuch-mua-new-mail :before 'load-mail-config)

(require 'messages-are-flowing)
(add-hook 'message-mode-hook 'messages-are-flowing-use-and-mark-hard-newlines)
(require 'mml)
(setq mml-enable-flowed t)
