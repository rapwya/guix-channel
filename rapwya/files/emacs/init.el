;; -*- lexical-binding: t; -*-

(setq
 ;; set the GC from the default 8kb to 100mb
 gc-cons-threshold (* 50 1000 1000)


 ;; no bell
 ring-bell-function nil

 ;; more detailed completions
 completions-detailed t)

;; Add configuration modules to load path
(add-to-list 'load-path '"/home/.config/emacs/modules")

;; no need to make backups
(setq
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil)

(require 'rw-core)
(require 'rw-dev)
(require 'rw-keys-evil)
(require 'rw-completion)
(require 'rw-theming)
