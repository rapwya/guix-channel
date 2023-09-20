;;; early-init.el --- Loads settings that don't have to do with the GUI.
;;; Commentary:

;;; Code:

;; Packages will be initialized by guix later.
(setq package-enable-at-startup nil)
(setq package-archives nil)

;; Prevent unwanted runtime builds; packages are compiled ahead-of-time when
;; they are installed and site files are compiled when gccemacs is installed.
(setq native-comp-jit-compilation nil)

;; Don't display the startup screen, message, or scratch buffer explanation
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; Clear away the menu and scroll bars
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(horizontal-scroll-bars) default-frame-alist)
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)

;;;early-init.el ends here
