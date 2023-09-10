;; -*- lexical-binding: t; -*-

;; -- Paren Matching --

(use-package smartparens
  :hook (prog-mode . smartparens-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode)

;; -- Git Integration --

(use-package magit
  :bind ("C-M-;" . magit-status-here))

(provide 'rw-dev)
