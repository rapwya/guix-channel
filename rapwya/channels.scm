(define-module (rapwya channels)
  #:use-module (guix channels))

(list
  (channel
    (name 'rapwya)
    (url "https://github.com/warthael/guix-channel")
    (branch "main")
    (introduction 
      (make-channel-introduction 
        "9b0c6cc74802490237f8d9a3c924201a6372ed07"
        (opengpg-fingerprint
          "363A 8281 E81D 6B7D 55B8  3145 EEEE 86B8 38F0 612E")))))
