(require 'w3m)

(global-set-key "\C-xm" 'browse-url-at-point)

(setq browse-url-browser-function 'w3m-browse-url)
(setq w3m-use-cookies t)

(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
