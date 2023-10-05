(define-module (rapwya packages xdisorg)
  #:use-module (guix download)
  #:use-module (gnu packages xdisorg))

(define-public pixman-0.42.2
  (package
    (inherit pixman)
    (name "pixman")
    (version "0.42.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://www.cairographics.org/releases/"
                                  "pixman-" version ".tar.gz"))
              (sha256
               (base32
                "0pk298iqxqr64vk3z6nhjwr6vjg1971zfrjkqy5r9zd2mppq057a"))))))
