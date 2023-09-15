;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(define-module (rapwya home warthael)
  #:use-module (gnu home)
  #:use-module (gnu packages)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (gnu home services shells)
  #:use-module (rapwya services emacs))

(define warthael-home
  (home-environment
    ;; Below is the list of packages that will show up in your
    ;; Home profile, under ~/.guix-home/profile.

    (packages (specifications->packages 
                (list "git" 
                      "openssh" 
                      "ungoogled-chromium" 
                      "font-jetbrains-mono" 
                      "font-awesome" 
                      "ripgrep" 
                      "exa" 
                      "neovim" 
                      "emacs-next" 
                      "alacritty")))

    ;; Below is the list of Home services.  To search for available
    ;; services, run 'guix home search KEYWORD' in a terminal.
    (services 
      (list (service home-emacs-config-service-type)))))

warthael-home
