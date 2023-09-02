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
         "emacs-undo-tree"

         ;; theming
         "emacs-doom-themes"
         "emacs-kind-icon"
         "emacs-doom-modeline"
         "emacs-minions"

         ;; org mode
         "emacs-org"
         "emacs-org-roam"

         ;; completions
         "emacs-corfu"
         "emacs-marginalia"
         "emacs-vertico"
         "emacs-marginalia"
         "emacs-orderless"

         ;; help to keep ~/.config/emacs clean
         "emacs-no-littering"

         ;; guix
         "emacs-guix")))

(define home-emacs-config-service-type
  (service-type (name 'home-emacs-config) 
                (description "Applies my personal emacs config") 
                (extensions 
                  (list (service-extension 
                          home-profile-service-type 
                          home-emacs-config-profile-service))) 
                (default-value #f)))
