(define-module (rapwya systems base) 
  #:use-module (srfi srfi-1)

  #:use-module (gnu)
  #:use-module (gnu system)
  #:use-module (gnu system nss)

  #:use-module (gnu packages cups)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages wm)

  #:use-module (gnu services)
  #:use-module (gnu services cups)
  #:use-module (gnu services desktop)
  #:use-module (gnu services networking)
  #:use-module (gnu services pm)
  #:use-module (gnu services ssh)
  #:use-module (gnu services xorg)

  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

(define %my-desktop-services
  (modify-services %desktop-services
    (delete slim-service-type)
    (delete screen-locker-service-type)

    ;; Add Nonguix substitutes
    (guix-service-type 
      config => (guix-configuration
                  (inherit config)
                  (substitute-urls 
                    (append (list "https://substitutes.nonguix.org") 
                            %default-substitute-urls))
                  (authorized-keys 
                    (append (list (local-file "../files/keys/nonguix-signing-key.pub")) 
                            %default-authorized-guix-keys))))

    ;; Allow OpenVPN to manage VPNs
    (network-manager-service-type 
      config => (network-manager-configuration
                  (inherit config)
                  (vpn-plugins
                    (list 
                      (specification->package "network-manager-openvpn")))))))

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

    (bootloader (bootloader-configuration 
                  (bootloader grub-efi-bootloader) 
                  (targets (list "/boot/efi")) 
                  (keyboard-layout keyboard-layout)))

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
    (packages (append (map specification->package
                           '("git"
                             "stow"

                             ;; SSL Root Certs - don't delete
                             "nss-certs" 

                             "brightnessctl"
                             "bluez"
                             "bluez-alsa"))
                      %base-packages))

    (services
      (append (list 
                    ;;(service xfce-desktop-service-type)
                    ;;(set-xorg-configuration
                      ;;(xorg-configuration (keyboard-layout keyboard-layout))) 

                    ;; Enable Printing and Scanning
                    (service cups-service-type 
                             (cups-configuration 
                               (web-interface? #t) 
                               (extensions 
                                 (list cups-filters))))
                    (service sane-service-type) 

                    (service greetd-service-type 
                             (greetd-configuration 
                               (greeter-supplementary-groups (list "video" "input")) 
                               (terminals 
                                 (list 
                                   ;; TTY1 is the graphical login screen for Sway 
                                   (greetd-terminal-configuration 
                                     (terminal-vt "1") 
                                     (terminal-switch #t)) 
                                   ;; Set up remaining TTYs for terminal use 
                                   (greetd-terminal-configuration (terminal-vt "2"))
                                   (greetd-terminal-configuration (terminal-vt "3"))))))

                    ;; Configure swaylock as a setuid program 
                    (service screen-locker-service-type 
                             (screen-locker-configuration 
                               (name "swaylock") 
                               (program (file-append swaylock "/bin/swaylock")) 
                               (using-pam? #t) 
                               (using-setuid? #f))) 


                    ;; Add udev rules for a few packages
                    (udev-rules-service 'pipewire-add-udev-rules pipewire)
                    (udev-rules-service 'brightnessctl-udev-rules brightnessctl)

                    ;; Power and thermal management services
                    (service thermald-service-type)
                    (service tlp-service-type)

              %my-desktop-services)))

    ;; Allow resolution of '.local' host names with mDNS
    (name-service-switch %mdns-host-lookup-nss)))
