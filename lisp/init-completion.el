;;; init-completion.el --- Minibuffer and in-buffer completion -*- lexical-binding: t; -*-

;; Replaces the old helm + auto-complete stack with the
;; vertico/orderless/marginalia/consult + corfu/cape combination.

(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-x C-r" . consult-recent-file)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)))

(use-package corfu
  :init (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.15)
  (corfu-auto-prefix 2)
  (corfu-cycle t))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(use-package savehist
  :ensure nil
  :init (savehist-mode))

(provide 'init-completion)
;;; init-completion.el ends here
