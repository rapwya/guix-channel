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

(define (home-emacs-config-profile-service config)
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

         ;; Utility packages for things like completions
         "emacs-corfu"
         "emacs-marginalia"
         "emacs-vertico"
         "emacs-marginalia"
         "emacs-orderless"
         "emacs-consult"
         "emacs-embark"

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

         "emacs-guix")))

(define home-emacs-config-service-type
  (service-type 
    (name 'home-emacs-config)
    (description "Applies my personal emacs config")
    (extensions
      (list (service-extension
              home-profile-service-type 
              home-emacs-config-profile-service) 
            (service-extension 
              home-xdg-configuration-files-service-type 
              `(("emacs/init.el" 
                 ,(computed-file "../files/emacs/init.el"))
                ("emacs/modules/rw-core.el" 
                 ,(computed-file "../files/emacs/modules/rw-core.el")) 
                ("emacs/modules/rw-completion.el" 
                 ,(computed-file "../files/emacs/modules/rw-completion.el"))
                ("emacs/modules/rw-theming.el"
                 ,(computed-file "../files/emacs/modules/rw-theming.el")) 
                ("emacs/modules/rw-dev.el"
                 ,(computed-file "../files/emacs/modules/rw-dev.el"))
                ("emacs/modules/rw-keys-evil.el" 
                 ,(computed-file "../files/emacs/modules/rw-keys-evil.el"))))))
    (default-value #f)))
