;; -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;
;; Paren Matching ;;
;;;;;;;;;;;;;;;;;;;;

(use-package smartparens
  :hook (prog-mode . smartparens-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode)

;;;;;;;;;;;;;;;;;;;;;
;; Git Integration ;;
;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :bind ("C-M-;" . magit-status-here))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Programming Languages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs-lisp-mode
  :hook (emacs-lisp-mode . flycheck-mode))

(use-package guile
  (setq geiser-default-implementation 'guile)
  (setq geiser-active-implementations '(guile))
  (setq geiser-implementations-alist '(((regexp "\\.scm$") guile))))


;; End
(provide 'rw-dev)
