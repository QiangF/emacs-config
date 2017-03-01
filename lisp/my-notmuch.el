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
      message-kill-buffer-on-exit t
      message-use-idna nil
      message-sendmail-envelope-from 'header
      mail-user-agent 'notmuch-user-agent)

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

(setq notmuch-fcc-dirs nil
      notmuch-search-oldest-first nil)

(define-key notmuch-hello-mode-map "g" #'notmuch-refresh-this-buffer)
(define-key notmuch-search-mode-map "g" #'notmuch-refresh-this-buffer)

(define-key notmuch-show-mode-map "r" 'notmuch-show-reply)
(define-key notmuch-show-mode-map "R" 'notmuch-show-reply-sender)

(setq message-citation-line-format "On %a, %d %b %Y, %f wrote:")
(setq message-citation-line-function 'message-insert-formatted-citation-line)

(setq lexical-binding t)

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

; use helm for notmuch address completion
(setq notmuch-address-selection-function
      (lambda (prompt collection initial-input)
        (completing-read prompt (cons initial-input collection) nil t nil 'notmuch-address-history)))

(setq process-connection-type nil)

(defun mail-log-add (strmsg &optional append)
  (write-region (concat (current-time-string) ": " strmsg "\n")
		nil mail-daemon-log-file append 'nomessage))

(defun done-all-sentinel (process event)
  (mail-log-add "Updating emacs buffers" t)
  (notmuch-refresh-all-buffers)
  (mail-log-add "Mail sync completed" t))

(defvar notmuch-config-file (concat config-file-directory "notmuch-config.gpg"))
(defvar mbsync-config-file (concat config-file-directory "mbsyncrc.gpg"))

(defun done-delete-sentinel (process event)
  (mail-log-add "Indexing mail" t)
  (set-process-sentinel (start-process "notmuch" nil "notmuch" "new") 'done-all-sentinel))

(defvar notmuch-expunge-cmd
  "notmuch search --format=text0 --output=files tag:deleted | xargs -0 --no-run-if-empty rm")

(defun done-sync-sentinel (process event)
  (mail-log-add "Expunging mail" t)
  (let ((expunge-proc (start-process-shell-command "notmuch-expunge" nil notmuch-expunge-cmd)))
    (set-process-sentinel expunge-proc 'done-delete-sentinel)))

(defun run-mail-sync ()
  (interactive)
  (mail-log-add "Fetching mail" t)
  (let ((mbsc-process (start-process "mbsync" nil "mbsync" "-c" "/dev/stdin" "-a")))
    (set-process-sentinel mbsc-process 'done-sync-sentinel)
    (process-send-string mbsc-process (read-gpg-file mbsync-config-file))
    (process-send-eof mbsc-process)))

(defvar mail-daemon-log-file
  (concat temporary-file-directory "mail-daemon-log"))

(defvar mail-daemon-current-session nil)

(defvar mail-daemon-timer nil)

(defun is-mail-daemon-started ()
  (interactive)
    (if (not (called-interactively-p 'any))
	mail-daemon-current-session
      (if mail-daemon-current-session
	  (message "Mail daemon started in current session")
	(if (and (server-running-p) (not server-process))
	    (message "Mail daemon started in another session (emacs daemon)")
	  (message "Mail daemon stopped")))))

(defun start-mail-daemon ()
  (interactive)
  (if (is-mail-daemon-started)
      (message "Mail daemon already started in current session")
    (if (and (server-running-p) (not server-process))
	; always assume emacs daemon has priority in running mail daemon
	(message "Not starting mail daemon: emacs daemon running in another process")
      (setq mail-daemon-timer (run-at-time "0 sec" 600 'run-mail-sync)
	    mail-daemon-current-session t)
      (mail-log-add "Mail daemon started")
      (message "Mail daemon started"))))

(defun stop-mail-daemon ()
  (interactive)
  (if (not (is-mail-daemon-started))
      (message "WARNING (stop-mail-daemon): Mail deamon is not started")
    (cancel-timer mail-daemon-timer)
    (setq mail-daemon-current-session nil
	  mail-daemon-timer nil)
    (mail-log-add "Mail daemon stopped")
    (message "Mail daemon stopped")))

(require 'nsm)
(setq nsm-settings-file (concat temporary-file-directory "network-security.data"))

(defvar notmuch-config-plain-file
  (concat temporary-file-directory "notmuch-config"))
