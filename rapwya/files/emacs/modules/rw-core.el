;; -*- lexical-binding: t; -*-

;; Change the user-emacs-directory to keep unwanted things out of ~/.emacs.d
(setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
      url-history-file (expand-file-name "url/history" user-emacs-directory))

;; Use no-littering to automatically set common paths to the new user-emacs-directory
;; Taken from System Crafters: https://github.com/daviwil/dotfiles/blob/guix-home/.emacs.d/modules/dw-core.el
(use-package no-littering
  :demand t
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

;;;;;;;;;;;;;;;;;;;;;;;;
;; Native Compilation ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Silence compiler warnings as they can be pretty disruptive
(setq native-comp-async-report-warnings-errors nil)

;; Set the right directory to store the native comp cache
(add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic Emacs Settings ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ensure we're using UTF-8
(set-charset-priority 'unicode)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8-unix)

;; show line numbers
(global-display-line-numbers-mode t)

;; Set font to be jetbrains mono
(set-face-attribute 'default nil
                   :font "JetBrains Mono"
                   :weight 'normal)

;;;;;;;;;;;;;;;;;;;;;;;;
;; Tab Bar Workspaces ;;
;;;;;;;;;;;;;;;;;;;;;;;;

(use-package tabspaces
  :ensure t
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

;;;;;;;;;;;;;
;; Editing ;;
;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Save Minibuffer History ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package savehist
  :config
  (setq history-length 25)
  (savehist-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make Help More Helpful ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

(provide 'rw-core)
