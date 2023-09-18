(define-module (rapwya services desktop)
  #:use-module (rapwya utils)

  #:use-module (gnu packages)
  #:use-module (gnu home services)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)

  #:use-module (guix gexp)
  #:use-module (guix transformations)

  #:export (home-desktop-service-type))

(define (get-desktop-packages config)
  (map specification->package
       (list 
         ;; Sway WM
         "sway"
         "swayidle"
         "swaylock"
         "swaybg"
         "waybar"
         "fuzzel"
         "gammastep"
         "network-manager-applet"
         "mako"

         ;; Needed for if/when we need an older xorg application
         "xorg-server-xwayland"

         ;; Fonts
         "font-jetbrains-mono" 
         "font-awesome" 
         "font-iosevka-aile"

         ;; Theming
         "matcha-theme"
         "papirus-icon-theme"

         ;; XDG Utils
         "xdg-desktop-portal"
         "xdg-desktop-portal-gtk"
         "xdg-desktop-portal-wlr"
         "xdg-utils"
         "xdg-dbus-proxy"
         "shared-mime-info"

         ;; Document reader, vim keybindings with pdf support
         "zathura"
         "zathura-pdf-mupdf")))

(define (get-desktop-environment-variables config)
  '(;; Set Wayland-specific environment variables (taken from RDE) 
    ("XDG_CURRENT_DESKTOP" . "sway")
    ("XDG_SESSION_TYPE" . "wayland")
    ;; todo: setup pipewire service and put this there
    ;;("RTC_USE_PIPEWIRE" . "true")
    ("SDL_VIDEODRIVER" . "wayland")
    ("MOZ_ENABLE_WAYLAND" . "1")
    ("CLUTTER_BACKEND" . "wayland")
    ("ELM_ENGINE" . "wayland_egl")
    ("ECORE_EVAS_ENGINE" . "wayland-egl")
    ("QT_QPA_PLATFORM" . "wayland-egl")
    ("_JAVA_AWT_WM_NONREPARENTING" . "1")))

(define (get-desktop-config-files config)
  (append 
    (make-file-pairs "sway")
    (make-file-pairs "waybar")))

(define home-desktop-service-type
  (service-type 
    (name 'home-desktop-service)
    (description "Installs Sway and programs related to it. Adds fonts and other desktop applications.")
    (extensions 
      (list (service-extension 
              home-profile-service-type 
              get-desktop-packages)
            (service-extension
              home-environment-variables-service-type
              get-desktop-environment-variables )
            (service-extension
              home-xdg-configuration-files-service-type 
              get-desktop-config-files)))
    (default-value #f)))
