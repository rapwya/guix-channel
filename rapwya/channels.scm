(define-module (rapwya channels)
  #:use-module (guix channels))

(list
  (channel
    (name 'rapwya)
    (url "https://github.com/warthael/guix-channel")
    (branch "main")
    (introduction 
      (make-channel-introduction 
        "7daea9edae2783efe0cfdc0b07782b9d8a45e6c0"
        (openpgp-fingerprint
          "363A 8281 E81D 6B7D 55B8  3145 EEEE 86B8 38F0 612E")))))
