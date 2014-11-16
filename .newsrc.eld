;; -*- mode:emacs-lisp; coding: utf-8-emacs; -*-
;; Gnus startup file.
;; Never delete this file -- if you want to force Gnus to read the
;; .newsrc file (if you have one), touch .newsrc instead.
(setq gnus-newsrc-file-version "Gnus v5.13")

(setq gnus-newsrc-last-checked-date '"Mon, 17 Nov 2014 01:54:37 +0200")

(setq gnus-newsrc-alist '(("nnfolder+archive:sent.2014-11" 3 nil ((unexist) (seen (1 . 7))) (nnfolder "archive" (nnfolder-directory "~/Mail/archive") (nnfolder-active-file "~/Mail/archive/active") (nnfolder-get-new-mail nil) (nnfolder-inhibit-expiry t))) ("nnmaildir+adiratcom:All" 3 ((1 . 55)) ((reply (4 . 5) 10 12 16 23 25 38 41)) "nnmaildir:adiratcom") ("nnmaildir+adiratcom:Inbox" 3 ((1 . 34)) ((unexist) (seen (2 . 34)) (reply (3 . 4) (7 . 8) 11 15 25 27)) "nnmaildir:adiratcom") ("nnmaildir+adiratcom:Sent" 3 ((1 . 30)) ((reply 6 20 22)) "nnmaildir:adiratcom") ("nnmaildir+adiratcom:Spam" 3 ((1 . 3)) nil "nnmaildir:adiratcom") ("nnmaildir+adiratcom:Trash" 3 ((1 . 36)) ((reply 6)) "nnmaildir:adiratcom") ("nndraft:drafts" 1 nil nil (nndraft "") ((gnus-dummy (gnus-draft-mode))))))

(setq gnus-server-alist '(("archive" nnfolder "archive" (nnfolder-directory "~/Mail/archive") (nnfolder-active-file "~/Mail/archive/active") (nnfolder-get-new-mail nil) (nnfolder-inhibit-expiry t))))

(setq gnus-zombie-list '("gwene.com.libsynpro.microbeworld.twiv.this.week.in.virology" "gwene.com.youtube.the.great.war" "gwene.org.biorxiv.connect.biorxiv.xml.php.subject.plant.bio"))

(setq gnus-topic-topology '(("Gnus" visible nil nil) (("misc" visible nil nil)) (("Mail" visible nil nil))))

(setq gnus-topic-alist '(("Mail" "nnmaildir+adiratcom:All" "nnmaildir+adiratcom:Inbox" "nnmaildir+adiratcom:All") ("misc" "nnfolder+archive:sent.2014-11" "nndraft:drafts") ("Gnus" "nnmaildir+adiratcom:All" "nnmaildir+adiratcom:Inbox" "nnmaildir+adiratcom:Sent" "nnmaildir+adiratcom:Spam" "nnmaildir+adiratcom:Trash")))
