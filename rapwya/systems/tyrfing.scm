(define-module (rapwya systems tyrfing)
  #:use-module (rapwya systems base)
  #:use-module (gnu packages file-systems)
  #:use-module (gnu services)
  #:use-module (gnu system)
  #:use-module (gnu system uuid)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system mapped-devices)
  #:use-module (nongnu packages linux))

(define-public machine-tyrfing 
  (operating-system 
    (inherit base-operating-system)
    (host-name "tyrfing")

    (mapped-devices 
      (list (mapped-device 
              (source (uuid "0cd131ec-bfaa-4b91-999f-5bf8a07ce704")) 
              (target "cryptroot") 
              (type luks-device-mapping))))

    ;; The list of file systems that get "mounted".  
    ;; The unique file system identifiers there ("UUIDs") can be obtained
    ;; by running 'blkid' in a terminal.
    (file-systems (cons* 
                    (file-system 
                      (mount-point "/") 
                      (device "/dev/mapper/cryptroot") 
                      (type "ext4") 
                      (dependencies mapped-devices)) 
                    %base-file-systems))))

machine-tyrfing
