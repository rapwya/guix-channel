(define-module (rapwya utils)
  #:use-module (guix build utils)
  #:use-module (guix gexp)

  #:export (get-file-pairs))


(define (get-file-pairs dir)
  "Used to get the pairs of file-like objects 
to be consumed by home-xdg-service-config-type.
This will slurp up any file and folders under \"dir\".
Dir is appended to $HOME/guix-channel/rapway/files."
  (let* ((files-dir 
           (string-append (getenv "HOME") "/guix-channel/rapwya/files/"))
         (processing-dir (string-append files-dir dir)))
    (map 
      (lambda (f) 
        `(,(substring f (string-length files-dir)) ,(local-file f))) 
      (find-files processing-dir))))
