;; -*- lexical-binding: t; -*-

;; needed to provide more vim-like undo
(use-package undo-tree
  :config
  (setq undo-tree-auto-save-history nil)
  (global-undo-tree-mode 1))

(use-package evil
  :demand t
  :init
  ;; pre-load configuration
  (setq evil-want-configuration t)
  (setq evil-want-keybinding nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)

  ;; Activate Evil Mode
  :config
  (evil-mode 1)
  
  ;; Clear the binding of C-k so that it doesn't conflict with Corfu
  ;; NOTE: maybe set them to be C-p and C-n?
  (define-key evil-insert-state-map (kbd "C-k") nil)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (setq-default evil-shift-width 2)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-outline-bind-tab-p nil)
  :config
  (evil-collection-init))

(use-package evil-org
  :after (evil org)
  :hook ((org-mode . evil-org-mode))
  :config
  (evil-org-set-key-theme '(navigation todo insert textobjects additional)))

(with-eval-after-load 'org
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-j") 'org-next-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-k") 'org-previous-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-j") 'org-metadown)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-k") 'org-metaup))

(provide 'rw-keys-evil)
