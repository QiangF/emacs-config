(require 'newsticker)
(require 'w3m)

(setq newsticker-html-renderer 'w3m-region)

; We want our feeds pulled every 10 minutes.
(setq newsticker-retrieval-interval 3600)
(setq newsticker-automatically-mark-visited-items-as-old t)
(setq newsticker-automatically-mark-items-as-old t)

(setq newsticker-treeview-treewindow-width 20)
(setq newsticker-treeview-listwindow-height 10)

; Setup the feeds
(setq newsticker-url-list-defaults nil)
(setq newsticker-url-list
      '(("Truth Inside the Lie" "http://thetruthinsidethelie.blogspot.com/feeds/posts/default" nil nil nil)
	("Luke Palmer" "http://lukepalmer.wordpress.com/feed/" nil nil nil)
	("Savatie Bastovoi" "http://savatie.wordpress.com/feed/" nil nil nil)
	("Firmilian Gherasim" "http://firmilianos.blogspot.com/feeds/posts/default" nil nil nil)
	("Phoronix" "http://www.phoronix.com/rss.php" nil nil nil)))

(global-set-key (kbd "C-c r") 'newsticker-treeview)

(newsticker-start)
