(define-module (rapwya packages freedesktop)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages python))

;; TODO: eventually this will be mainstraimed and won't be needed
(define-public libinput-minimal-1.24.0
  (package
    (inherit libinput-minimal)
    (name "libinput-minimal")
    (version "1.24.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://gitlab.freedesktop.org/libinput/libinput.git")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0wnqfnxxvf9jclh64hrb0scn3s1dmwdkmqf7hp0cfmjz5n5nnv7d"))))
    (native-inputs
     (modify-inputs (package-native-inputs libinput)
       (append python-minimal-wrapper python-pytest)))))
