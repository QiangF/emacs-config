(require 'bb-mode)

(mapc (apply-partially 'add-to-list 'auto-mode-alist)
      '(("\\.bb\\'" . bb-mode)
	("\\.inc\\'" . bb-mode)
	("\\.bbclass\\'" . bb-mode)
	("\\.bbappend\\'" . bb-mode)))
