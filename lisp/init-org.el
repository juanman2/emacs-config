;;; init-org.el --- Org mode -*- lexical-binding: t; -*-

(use-package org
  :ensure nil
  :custom
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-confirm-babel-evaluate nil)
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (shell . t))))

(provide 'init-org)
;;; init-org.el ends here
