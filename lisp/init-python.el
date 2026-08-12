;;; init-python.el --- Python support -*- lexical-binding: t; -*-

;; Requires `pyright` on PATH (npm install -g pyright).

(add-to-list 'auto-mode-alist '("\\.py\\'" . python-ts-mode))
(setq python-indent-offset 4)
(setq python-shell-interpreter "python3")

;; Detects the project's venv/poetry/pipenv/conda environment and
;; points python-shell/eglot at its interpreter, replacing the old
;; elpy-enable virtualenv handling.
(use-package pet
  :hook (python-ts-mode . pet-mode))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((python-ts-mode python-mode) . ("pyright-langserver" "--stdio"))))

(add-hook 'python-ts-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'eglot-format-buffer nil t)))

(provide 'init-python)
;;; init-python.el ends here
