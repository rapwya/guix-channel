(define-module (rapwya systems base) 
  #:use-module (srfi srfi-1)
  #:use-module (gnu)
  #:use-module (gnu system)
  #:use-module (gnu system nss)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages networking)
  #:use-module (gnu services desktop)
  #:use-module (gnu services cups)
  #:use-module (gnu services networking)
  #:use-module (gnu services ssh)
  #:use-module (gnu services xorg)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

(define-public base-operating-system 
  (operating-system
    ;; Use non-free kernel and firmware
    (kernel linux) 

    ;; Apply Microcode Patches for Intel CPUs 
    ;; These are recommended to be applied to your system for security reasons.
    (initrd (lambda (file-systems . rest) 
              (apply microcode-initrd file-systems 
                     #:initrd base-initrd 
                     #:microcode-packages (list intel-microcode) 
                     rest))) 

    ;; Just use firmware for Intel devices 
    (firmware (cons* iwlwifi-firmware 
                     ibt-hw-firmware 
                     %base-firmware)) 

    (locale "en_US.utf8") 
    (timezone "America/Los_Angeles")
    (keyboard-layout (keyboard-layout "us")) 
    (host-name "base-system")

   ;; without this Guix will freak out
   ;; this is meant to be overwritten.
   (file-systems (cons*
                  (file-system
                   (mount-point "/tmp")
                   (device "none")
                   (type "tmpfs")
                   (check? #f))
                  %base-file-systems))

    ;; The list of user accounts ('root' is implicit).
    (users (cons* (user-account
                    (name "warthael")
                    (comment "Wyatt")
                    (group "users")
                    (home-directory "/home/warthael")
                    (shell (file-append zsh "/bin/zsh"))
                    (supplementary-groups '("wheel" "netdev" "audio" "video"))) 
                  %base-user-accounts))

    ;; Packages installed system-wide.  
    ;; Users can also install packages under their own account: use 'guix search KEYWORD' to search
    ;; for packages and 'guix install PACKAGE' to install a package.
    (packages (append (map specification->package
                           '("git"
                             "stow"
                             "neovim"
                             "emacs"
                             "sway"
                             "nss-certs"))
                      %base-packages))

    ;; Below is the list of system services.
    ;; To search for available services, run 'guix system search KEYWORD' in a terminal.
    (services
      (append (list (service xfce-desktop-service-type)
                    (service cups-service-type)
                    (set-xorg-configuration
                      (xorg-configuration (keyboard-layout keyboard-layout))))

              ;; This is the default list of services we are appending to.
              %desktop-services))

    (bootloader (bootloader-configuration 
                  (bootloader grub-bootloader)
                  (targets (list "/dev/sda"))
                  (keyboard-layout keyboard-layout)))))
