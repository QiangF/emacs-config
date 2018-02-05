; -*- lexical-binding: t -*-
(require 'notmuch)

(setq notmuch-show-logo nil
      notmuch-always-prompt-for-sender t
      notmuch-hello-thousands-separator ""
      notmuch-show-empty-saved-searches t
      notmuch-show-all-tags-list t
      notmuch-crypto-process-mime t
      notmuch-address-internal-completion '(received nil))

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
      message-default-mail-headers "Cc: \n"
      message-auto-save-directory nil
      mail-user-agent 'notmuch-user-agent
      notmuch-message-replied-tags nil)

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

(setq notmuch-search-default-sort-order 'newest-first)

(define-key notmuch-hello-mode-map "g" 'notmuch-refresh-this-buffer)
(define-key notmuch-search-mode-map "g" 'notmuch-refresh-this-buffer)

(define-key notmuch-show-mode-map "r" 'notmuch-show-reply)
(define-key notmuch-show-mode-map "R" 'notmuch-show-reply-sender)

(define-key notmuch-hello-mode-map "a" 'widget-button-press)

(setq message-citation-line-format "On %a, %d %b %Y, %f wrote:")
(setq message-citation-line-function 'message-insert-formatted-citation-line)

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

(require 'nsm)
(setq nsm-settings-file (concat temporary-file-directory "network-security.data"))

(setq notmuch-command "notmuch-remote")

(defun done-sync-sentinel (process event)
  (notmuch-refresh-all-buffers)
  (message "Mail sync complete"))

(defun run-mail-sync ()
  (interactive)
  (set-process-sentinel (start-process "trigger-mail-sync" nil "trigger-mail-sync")
			'done-sync-sentinel))

(defun my-message-current-line-cited-p ()
  "Indicate whether the line at point is a cited line."
  (save-match-data
    (string-match (concat "^" message-cite-prefix-regexp)
                  (buffer-substring (line-beginning-position) (line-end-position)))))

(defun notmuch-download-message-filter (proc string)
  (let* ((full-remote-name (replace-regexp-in-string "\n\\'" "" string))
	 (mail-name (file-name-nondirectory full-remote-name))
	 (local-dir (read-from-minibuffer "Destination directory: "))
	 (local-name (read-from-minibuffer "File name: "))
	 (full-dir (if (eq (substring local-dir -1) "/") local-dir (concat local-dir "/")))
	 (full-local-name (concat full-dir local-name)))
;    TODO: Fix case when directory doesn't exist because I removed helm entirely
;    (when (and local-dir (not (file-exists-p local-dir)))
;      (helm-ff--mkdir local-dir))
    (start-process "mail-scp" nil "mail-scp" full-remote-name full-local-name)
    (message "Succesfully saved %s" full-local-name)))

(defun notmuch-download-message ()
  (interactive)
  (start-process "notmuch-download-message" nil notmuch-command
		 "search" "--output=files" (notmuch-show-get-message-id))
  (set-process-filter (get-process "notmuch-download-message")
		      'notmuch-download-message-filter))

(setq notmuch-hello-auto-refresh nil)

(setq notmuch-search-result-format '(("date" . "%12s ")
				     ("filesize" . "%6s ")
				     ("count" . "%-7s ")
				     ("authors" . "%-20s ")
				     ("subject" . "%s ")
				     ("tags" . "(%s)")))
