;; -*- lexical-binding: t; -*-

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-gruvbox t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config))

;; todo: create a fn to toggle between light and dark mode on key-press

(use-package minions
  :hook (mood-line-mode . minions-mode))

(use-package mood-line
  :config
  (setq mood-line-glyph-alist mood-line-glyphs-fira-code)
  (mood-line-mode))

;; End
(provide 'rw-theming)
