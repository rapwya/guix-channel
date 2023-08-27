;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules 
  (gnu) 
  (gnu packages shells)
  (nongnu packages linux)
  (nongnu system linux-initrd))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
  (kernel linus)
  ;; Apply Microcode Patches for Intel CPUs
  (initrd (lambda (file-systems . rest)
          (apply microcode-initrd file-systems
                 #:initrd base-initrd
                 #:microcode-packages (list intel-microcode)
                 rest)))
  ;; Just use firmware for Intel machines
  (firmware (cons* iwlwifi-firmware 
                   ibt-hw-firmware
                   %base-firmware))
  (locale "en_US.utf8")
  (timezone "America/Los_Angeles")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "tyrfing")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "warthael")
                  (comment "Wyatt")
                  (group "users")
                  (home-directory "/home/warthael")
                  (shell (file-append zsh "/bin/zsh"))
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (map specification->package
                         '("git"
                           "stow"
                           "neovim"
                           "emacs"
                           "sway"
                           "nss-certs"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service xfce-desktop-service-type)
                 (service cups-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))))

           ;; This is the default list of services we
           ;; are appending to.
           %desktop-services))
  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets (list "/dev/sda"))
                (keyboard-layout keyboard-layout)))
  (mapped-devices (list (mapped-device
                          (source (uuid
                                   "0cd131ec-bfaa-4b91-999f-5bf8a07ce704"))
                          (target "cryptroot")
                          (type luks-device-mapping))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptroot")
                         (type "ext4")
                         (dependencies mapped-devices)) %base-file-systems)))
