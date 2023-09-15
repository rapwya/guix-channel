;; -*- lexical-binding: t; -*-

;; Turn on indentation and auto-fill mode for Org files
(defun rw/org-mode-setup ()
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq corfu-auto nil)
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . rw/org-mode-setup)
  :bind (("C-c o a" . org-agenda)
         ("C-c o t" . (lambda ()
                        (interactive)
                        ;; Display tasks after selecting tags to filter by
                        (org-tags-view t)))
         :map org-mode-map
              ("M-n" . org-move-subtree-down)
              ("M-p" . org-move-subtree-up))
  :config
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-use-outline-path t))

(use-package org-modern
  :hook (org-mode . org-modern-mode))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/roam/notes")
  (org-roam-dailies-directory "~/roam/dailies")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                         "#+title: ${title}\n")
      :unnarrowed t)))
  (org-roam-dailies-capture-templates
   `(("d" "default" entry
      "* %?"
      :if-new (file+head ,rw/daily-note-filename
                         ,rw/daily-note-header))
     ("t" "task" entry
      "* TODO %?\n  %U\n  %a\n  %i"
      :if-new (file+head+olp ,rw/daily-note-filename
                             ,rw/daily-note-header
                             ("Tasks"))
      :empty-lines 1)
     ("j" "journal" entry
      "* %<%I:%M %p> - Journal  :journal:\n\n%?\n\n"
      :if-new (file+head+olp ,rw/daily-note-filename
                             ,rw/daily-note-header
                             ("Journal")))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (setq rw/daily-note-filename "%<%Y-%m-%d>.org" 
        rw/daily-note-header "#+title: %<%Y-%m-%d %a>\n\n[[roam:%<%Y-%B>]]\n\n")

  (org-roam-db-autosync-mode))

(use-package consult-notes
  :ensure t
  :bind (("C-c n f" . consult-notes))
  :custom
  (consult-notes-denote-display-id nil)
  :config
  (consult-notes-org-roam-mode))

(provide 'rw-org)
