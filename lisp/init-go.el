;;; init-go.el --- Go support -*- lexical-binding: t; -*-

;; Requires `gopls` on PATH (go install golang.org/x/tools/gopls@latest).

(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(setq-default go-ts-mode-indent-offset 4)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '((go-ts-mode go-mode) . ("gopls"))))

(add-hook 'go-ts-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'eglot-format-buffer nil t)
            (add-hook 'before-save-hook #'eglot-code-action-organize-imports nil t)))

(provide 'init-go)
;;; init-go.el ends here
