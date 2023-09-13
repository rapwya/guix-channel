(define-module (rapwya packages emacs-xyz)
  #:use-module (guix git-download)
  #:use-module (guix build-system emacs))

(define-public emacs-tabspaces
  (package
    (name "emacs-tabspaces")
    (version "20230902.1522")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/mclear-tools/tabspaces.git")
                    (commit "6b430ace803c8b9e2310d618e9e98c952fc3c9e2")))
              (sha256 (base32
                       "1a65hs2614gvsbkchlqhpraf1sqgnx42ri52mr6sznhi19ysjwrz"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-project))
    (home-page "https://github.com/mclear-tools/tabspaces")
    (synopsis "Leverage tab-bar and project for buffer-isolated workspaces")
    (description 
      "This package provides several functions to facilitate a single frame-based
    workflow with one workspace per tab, integration with project.el (for
    project-based workspaces) and buffer isolation per tab (i.e.  a \"tabspace\"
    workspace).  The package assumes project.el and tab-bar.el are both present
    (they are built-in to Emacs 27.1+).  This file is not part of GNU Emacs. ;
    Acknowledgements Much of the package code is inspired by: -
    https://github.com/kaz-yos/emacs -
    https://github.com/wamei/elscreen-separate-buffer-list/issues/8 -
    https://www.rousette.org.uk/archives/using-the-tab-bar-in-emacs/ -
    https://github.com/minad/consult#multiple-sources -
    https://github.com/florommel/bufferlo")
    (license #f)))
