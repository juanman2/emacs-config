;;; init-eglot.el --- LSP client base config -*- lexical-binding: t; -*-

;; eglot ships with Emacs 29+; it's the LSP client for both Go and
;; Python here, replacing elpy (Python) and godef (Go) from the old
;; config. Language-specific server registration lives in
;; init-go.el/init-python.el, not here.

(use-package eglot
  :ensure nil
  :hook ((go-ts-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure))
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  :bind (:map eglot-mode-map
              ("C-c l r" . eglot-rename)
              ("C-c l a" . eglot-code-actions)
              ("C-c l f" . eglot-format-buffer)))

(provide 'init-eglot)
;;; init-eglot.el ends here
