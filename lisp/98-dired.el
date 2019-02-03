(require 'dired-x)

(setq dired-listing-switches "-alh"
      dired-recursive-deletes 'always)

(define-key dired-mode-map (kbd "C-l") 'dired-jump)
(global-set-key (kbd "C-x l") 'dired-jump)
(global-set-key (kbd "C-x C-l") 'dired-jump)

(define-key dired-mode-map "a" 'dired-find-file)
(define-key dired-mode-map "f" 'find-file)

(setq shplay-hostname nil)

(defun stop-play-file ()
  (interactive)
  (when shplay-hostname
    (start-process "shplay-remote" nil "shplay-remote" shplay-hostname "pkill" "playhrt")
    (setq shplay-hostname nil)))

(defun play-file ()
  (interactive)
  (when (dired-get-marked-files)
    (let* ((diredfiles (dired-get-marked-files))
	   (userhost (cadr (split-string (car diredfiles) ":")))
	   (files (mapcar (lambda (f) (car (last (split-string f ":")))) diredfiles))
	   (filesstr (string-join files "|||")))
      (when shplay-hostname (stop-play-file) (sleep-for 2))
      (start-process "shplay-remote" nil "shplay-remote" userhost "shplay" filesstr)
      (setq shplay-hostname userhost))))

(define-key dired-mode-map (kbd "P") 'play-file)
(define-key dired-mode-map (kbd "S") 'stop-play-file)

(define-key dired-mode-map (kbd "c") 'find-file)
