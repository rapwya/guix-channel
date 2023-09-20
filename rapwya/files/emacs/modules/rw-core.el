;;; rw-core --- provides settings that change core emacs behavior. -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;; -- Configuration Paths --

;; Change the user-emacs-directory to keep unwanted things out of ~/.emacs.d
(setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
      url-history-file (expand-file-name "url/history" user-emacs-directory))

;; Use no-littering to automatically set common paths to the new user-emacs-directory
;; Taken from System Crafters: https://github.com/daviwil/dotfiles/blob/guix-home/.emacs.d/modules/dw-core.el
(use-package no-littering
  :config
  ;; Set the custom-file to a file that won't be tracked by Git
  (setq custom-file (if (boundp 'server-socket-dir)
                        (expand-file-name "custom.el" server-socket-dir)
                      (no-littering-expand-etc-file-name "custom.el")))
  (when (file-exists-p custom-file)
    (load custom-file t))

  ;; Don't litter project folders with backup files
  (let ((backup-dir (no-littering-expand-var-file-name "backup/")))
    (make-directory backup-dir t)
    (setq backup-directory-alist
          `(("\\`/tmp/" . nil)
            ("\\`/dev/shm/" . nil)
            ("." . ,backup-dir))))

  ;; Tidy up auto-save files
  (let ((auto-save-dir (no-littering-expand-var-file-name "auto-save/")))
    (make-directory auto-save-dir t)
    (setq auto-save-file-name-transforms
          `(("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
             ,(concat temporary-file-directory "\\2") t)
            ("\\`\\(/tmp\\|/dev/shm\\)\\([^/]*/\\)*\\(.*\\)\\'" "\\3")
            ("." ,auto-save-dir t)))))

;;; -- Native Compilation --

;; Silence compiler warnings as they can be pretty disruptive
(setq native-comp-async-report-warnings-errors nil)

;; Set the right directory to store the native comp cache
(add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory))

;;; --  Basic Emacs Settings --

;; ensure we're using UTF-8
(set-charset-priority 'unicode)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8-unix)

;; show line numbers
(global-display-line-numbers-mode t)

;; Set font to be jetbrains mono
(set-face-attribute 'default nil
                   :font "JetBrains Mono"
                   :weight 'normal
                   :height 120)

(set-face-attribute 'fixed-pitch nil
                   :font "JetBrains Mono"
                   :weight 'normal
                   :height 120)

;; Set Iosevka Aile for non-coding spots
(set-face-attribute 'variable-pitch nil
                    :font "Iosevka Aile"
                    :weight 'normal
                    :height 130)


;;; -- Tab Bar Workspaces --

(use-package tabspaces
  :config
  (tabspaces-mode 1)
  (setq tabspaces-use-filtered-buffers-as-default t
        tabspaces-default-tab "Main"
        tabspaces-remove-to-default t
        tabspaces-include-buffers '("*scratch*")))

(with-eval-after-load 'consult
  ;; Hide full buffer list by default (still available with "b" prefix)
  (consult-customize consult--source-buffer :hidden t :default nil)

  (setq consult-ripgrep-args "rg --null \
        --hidden \
        --line-buffered \
        --max-columns=1000 \
        --path-separator / \
        --smart-case \
        --no-heading \
        --line-number \
        --search-zip .")

  ;; Set consult-workspace buffer list
  (defvar consult--source-workspace
    (list :name "Workspace Buffers"
          :narrow ?w
          :history 'buffer-name-history
          :category 'buffer
          :state #'consult--buffer-state
          :default t
          :items (lambda () (consult--buffer-query
                             :predicate #'tabspaces--local-buffer-p
                             :sort 'visibility
                             :as #'buffer-name)))

    "Set workspace buffer list for consult-buffer.")
  (add-to-list 'consult-buffer-sources 'consult--source-workspace))

(global-set-key (kbd "C-M-j") #'consult-buffer)
(global-set-key (kbd "C-M-k") #'tab-bar-switch-to-tab)
(global-set-key (kbd "C-M-n") #'tab-bar-switch-to-next-tab)

(setq tab-bar-close-button-show nil
      tab-bar-auto-width nil
      tab-bar-format '(tab-bar-format-menu-bar
                       tab-bar-format-history
                       tab-bar-format-tabs-groups
                       tab-bar-separator
                       tab-bar-separator
                       tab-bar-format-align-right
                       tab-bar-format-global))

;;; -- Editing --

(setq-default tab-width 2)

(setq-default indent-tabs-mode nil)

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package super-save
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t))

(use-package avy
  :bind (("C-'" . avy-goto-char)
         ("C-;" . avy-goto-word-1)))

(use-package ace-window
  :bind (("M-o" . ace-window))
  :custom
  (aw-scope 'frame)
  (aw-minibuffer-flag t)
  :config
  (ace-window-display-mode 1))

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

(use-package editorconfig
  :config
  (editorconfig-mode 1))

;;; -- Dired --

;; You must run (all-the-icons-install-fonts) after install!
(use-package all-the-icons-dired)
(use-package dired-ranger)
(use-package dired-collapse)

(defun rw/dired-mode-hook ()
  (interactive)
  (dired-hide-details-mode 1)
  (unless (s-equals? "/gnu/store/" (expand-file-name default-directory))
    (all-the-icons-dired-mode 1))
  (hl-line-mode 1))

(use-package dired
  :config
  (setq dired-listing-switches "-agho --group-directories-first"
        dired-omit-files "^\\.[^.].*"
        dired-omit-verbose nil
        dired-hide-details-hide-symlink-targets nil
        delete-by-moving-to-trash t)

  (autoload 'dired-omit-mode "dired-x")

  (add-hook 'dired-load-hook
            (lambda ()
              (interactive)
              (dired-collapse)))

  (add-hook 'dired-mode-hook #'rw/dired-mode-hook)

  (global-set-key (kbd "s-e") #'dired-jump)

  (let ((keys '(("h" . dired-single-up-directory)
                ("H" . dired-omit-mode)
                ("l" . dired-single-buffer)
                ("y" . dired-ranger-copy)
                ("X" . dired-ranger-move)
                ("p" . dired-ranger-paste))))
    (dolist (key keys)
      (if (featurep 'evil)
          (evil-collection-define-key 'normal 'dired-mode-map (kbd (car key)) (cdr key))
        (define-key dired-mode-map (kbd (car key)) (cdr key))))))

(use-package openwith
  :config
  (setq openwith-associations
        (list
         (list (openwith-make-extension-regexp
                '("pdf"))
               "zathura"
               '(file)))))

;;; -- Save Minibuffer History --

(use-package savehist
  :config
  (setq history-length 25)
  (savehist-mode 1))

;;; -- Make Help More Helpful --

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind (([remap describe-function] . helpful-function)
         ([remap describe-symbol] . helpful-symbol)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-command] . helpful-command)
         ([remap describe-key] . helpful-key)))

;; Load the info system for info files
(add-to-list 'auto-mode-alist '("\\.info\\'" . Info-on-current-buffer))

;; Start server
(server-start)

;;; Provide
(provide 'rw-core)
;;; rw-core.el ends here
