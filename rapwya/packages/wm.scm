(define-module (rapwya packages wm)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system meson)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)

  #:use-module (gnu packages autotools)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages pciutils)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages web)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg)

  #:use-module (rapwya packages freedesktop)
  #:use-module (rapwya packages xdisorg))

(define hwdata-for-hyprland
  (package
   (inherit hwdata)
   (arguments
    (substitute-keyword-arguments
     (package-arguments hwdata)
     ((#:phases _)
      #~%standard-phases)))
   (outputs
    '("out"))))

(define libdisplay-info-for-hyprland
  (package
   (name "libdisplay-info")
   (version "0.1.1")
   (source
    (origin
     (method git-fetch)
     (uri
      (git-reference
       (url "https://gitlab.freedesktop.org/emersion/libdisplay-info")
       (commit version)))
     (file-name
      (git-file-name name version))
     (sha256
      (base32
       "1ffq7w1ig1y44rrmkv1hvfjylzgq7f9nlnnsdgdv7pmcpfh45pgf"))))
   (build-system meson-build-system)
   (arguments
    '(#:tests? #f))
   (native-inputs
    (list hwdata-for-hyprland pkg-config python-minimal-wrapper))
   (home-page "https://emersion.pages.freedesktop.org/libdisplay-info/")
   (synopsis "EDID and DisplayID library")
   (description "This package provides an EDID and DisplayID library.")
   (license license:expat)))

(define udis86-for-hyprland
  (let
      ((revision "186")
       (commit "5336633af70f3917760a6d441ff02d93477b0c86"))
    (package
     (name "udis86")
     (version
      (git-version "1.7.2" revision commit))
     (source
      (origin
       (method git-fetch)
       (uri
        (git-reference
         (url "https://github.com/canihavesomecoffee/udis86")
         (commit commit)))
       (file-name
        (git-file-name name version))
       (sha256
        (base32
         "0y5z1169wff578jylpafsww4px4y6gickhcs885a9c660d8xs9qy"))))
     (build-system gnu-build-system)
     (native-inputs
      (list autoconf automake libtool python-minimal-wrapper))
     (home-page "https://github.com/canihavesomecoffee/udis86")
     (synopsis "Disassembler Library for x86 and x86-64")
     (description
      "Udis86 is a disassembler for the x86 and x86-64 class of instruction
set architectures.  It consists of a C library called @code{libudis86} and a
command line tool called @code{udcli} that incorporates the library.")
     (license license:bsd-2))))

(define wlroots-for-hyprland
  (let
      ((base wlroots)
       (commit "98a745d926d8048bc30aef11b421df207a01c279"))
    (package
     (inherit base)
     (name "wlroots")
     (version
      (git-version "0.16.0" "735" commit))
     (source
      (origin
       (method git-fetch)
       (uri
        (git-reference
         (url "https://gitlab.freedesktop.org/wlroots/wlroots.git")
         (commit commit)))
       (file-name
        (git-file-name name version))
       (sha256
        (base32
         "0hwwpimmxwbpa1a7dqf6pcwxq9yanzq6l4q52pc90iyagcci8hic"))))
     (propagated-inputs
      (modify-inputs
       (package-propagated-inputs base)
       (append libdisplay-info-for-hyprland libxcb xcb-util-renderutil)
       (replace "libinput-minimal" libinput-minimal-1.23.0)
       (replace "pixman" pixman-0.42.2)))
     (native-inputs
      (modify-inputs
       (package-native-inputs base)
       (replace "hwdata"
                `(,hwdata-for-hyprland "out")))))))

(define-public hyprland-protocols
  (package
   (name "hyprland-protocols")
   (version "0.2")
   (source
    (origin
     (method git-fetch)
     (uri
      (git-reference
       (url "https://github.com/hyprwm/hyprland-protocols")
       (commit
        (string-append "v" version))))
     (file-name
      (git-file-name name version))
     (sha256
      (base32
       "1drjznj7fn6m5m6skhzh0p031cb5x0bb4i56jxnxwpwaa71g1z20"))))
   (build-system meson-build-system)
   (home-page "https://hyprland.org")
   (synopsis "Wayland protocol extensions for Hyprland.")
   (description
    "Wayland protocol extensions for Hyprland.
This repository exists in an effort to bridge the gap between Hyprland and KDE/Gnome's functionality.
Since @code{wlr-protocols} is closed for new submissions, and @code{wayland-protocols} is very slow with changes,
this repo will hold protocols used by Hyprland to bridge the aforementioned gap.")
   (license license:bsd-3)))

(define meson-build-patch
  (origin
   (method url-fetch)
   (uri
    (string-append "https://github.com/hyprwm/Hyprland" "/raw/"
                   "0.31.0"
                   "/nix/patches/meson-build.patch"))
   (sha256
    (base32 "0czc8238vjhsfnhrya6chcvy922f40nlqa4j5mq6f9h002ag9bhk"))))


(define-public hyprland
  (package
   (name "hyprland")
   (version "0.31.0")
   (source
    (origin
     (method git-fetch)
     (uri
      (git-reference
       (url "https://github.com/hyprwm/Hyprland")
       (commit
        (string-append "v" version))))
     (file-name (git-file-name name version))
     (modules '((guix build utils)))
     (snippet '(delete-file-recursively "nix"))
     (sha256
      (base32
       "0di528cnphxsr2hwg5bd4rl9nkkq8q41dc7y1sij7wji22xgafw6"))))
   (build-system meson-build-system)
   (arguments
    (list #:build-type "release"
          #:phases
          #~(modify-phases %standard-phases
                           (add-after 'unpack 'fix-path
                                      (lambda*
                                          (#:key inputs #:allow-other-keys)
                                        (substitute* "src/render/OpenGL.cpp"
                                                     (("/usr")
                                                      #$output))
                                        (substitute*
                                         (find-files "src" "\\.cpp")
                                         (("(execAndGet\\(\\(?\")\\<(cat|fc-list|lspci|nm)\\>"
                                           _ pre cmd)
                                          (format #f "~a~a"
                                                  pre
                                                  (search-input-file
                                                   inputs
                                                   (string-append "/bin/" cmd))))))))))
   (native-inputs
    (list gcc-13 jq pkg-config))
   (inputs
    (list hyprland-protocols
          pango
          pciutils
          udis86-for-hyprland
          wlroots-for-hyprland))
   (home-page "https://hyprland.org")
   (synopsis "Dynamic tiling Wayland compositor based on wlroots")
   (description
    "Hyprland is a dynamic tiling Wayland compositor based on @code{wlroots}
that doesn't sacrifice on its looks.  It supports multiple layouts, fancy
effects, has a very flexible IPC model allowing for a lot of customization, and
more.")
   (license license:bsd-3)))
