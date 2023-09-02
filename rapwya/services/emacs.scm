(define module (rapwya home-services emacs)
  #:use-module (gnu packages)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu home services)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (guix transformation)

  #:export-module (home-emacs-config-service-type))

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

(define (home-emacs-config-service-type
          (service-type (name 'home-emacs-config)
                        (description "Applies my personal emacs config")
                        (extensions
                          (list (service-extension
                                  home-profile-service-type
                                  home-emacs-config-profile-service)))
                        (default-value #f))))
