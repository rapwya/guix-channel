(define-module (rapwya services emacs)
  #:use-module (gnu packages)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu home services)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (guix transformations)

  #:export (home-emacs-config-service-type))

(define (get-emacs-packages config)
  (map specification->package
       (list 
         ;; git support
         "emacs-magit"

         ;; evil mode
         "emacs-evil"
         "emacs-evil-collection"
         "emacs-evil-nerd-commenter"
         "emacs-undo-tree"

         ;; theming
         "emacs-doom-themes"
         "emacs-kind-icon"
         "emacs-doom-modeline"
         "emacs-minions"

         "emacs-smartparens"
         "emacs-rainbow-delimiters"
         "emacs-rainbow-mode"

         ;; org mode
         "emacs-org"
         "emacs-org-roam"
         "emacs-org-modern"

         ;; Utility packages for things like completions
         "emacs-corfu"
         "emacs-marginalia"
         "emacs-vertico"
         "emacs-marginalia"
         "emacs-orderless"
         "emacs-embark"
         "emacs-consult"
         "emacs-consult-notes"

         ;; Move between the screen and windows easily
         "emacs-avy"
         "emacs-ace-window"

         ;; buffer isolated workspaces
         "emacs-tabspaces"

         ;; save all buffers
         "emacs-super-save"

         ;; help to keep ~/.config/emacs clean
         "emacs-no-littering"

         ;; makes the help menu better
         "emacs-helpful"

         "emacs-use-package"
         "emacs-guix")))

(define (get-emacs-config-files config)
  `(("emacs/early-init.el" ,(local-file "../files/emacs/early-init.el"))
    ("emacs/init.el" ,(local-file "../files/emacs/init.el")) 
    ("emacs/modules/rw-core.el" ,(local-file "../files/emacs/modules/rw-core.el"))
    ("emacs/modules/rw-completion.el" ,(local-file "../files/emacs/modules/rw-completion.el"))
    ("emacs/modules/rw-theming.el" ,(local-file "../files/emacs/modules/rw-theming.el"))
    ("emacs/modules/rw-dev.el" ,(local-file "../files/emacs/modules/rw-dev.el")) 
    ("emacs/modules/rw-keys-evil.el" ,(local-file "../files/emacs/modules/rw-keys-evil.el"))
    ("emacs/modules/rw-org.el" ,(local-file "../files/emacs/modules/rw-org.el"))))

(define home-emacs-config-service-type
  (service-type 
    (name 'home-emacs-config)
    (description "Applies my personal emacs config")
    (extensions
      (list (service-extension
              home-profile-service-type 
              get-emacs-packages) 
            (service-extension 
              home-xdg-configuration-files-service-type 
              get-emacs-config-files)))
    (default-value #f)))
