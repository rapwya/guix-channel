;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu packages)
             (gnu services)
             (guix gexp)
             (gnu home services shells))

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages (specifications->packages (list "git"
                                            "openssh"
                                            "ungoogled-chromium"
                                            "icecat"
                                            "font-jetbrains-mono"
                                            "font-awesome"
                                            "alacritty"
                                            "zsh")))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list (service home-zsh-service-type
                  (home-zsh-configuration
                   (zshenv (list (local-file 
                                  "/home/warthael/.zshenv"
                                  "zshenv")))
                   (zprofile (list (local-file 
                                    "/home/warthael/.config/zsh/.zprofile"
                                    "zprofile")))
                   (zshrc (list (local-file 
                                 "/home/warthael/.config/zsh/.zshrc"
                                 "zshrc"))))))))
