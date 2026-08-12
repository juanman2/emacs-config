;;; init-markdown.el --- Markdown support -*- lexical-binding: t; -*-

;; No LSP server or tree-sitter grammar in wide use for Markdown, so
;; unlike init-go.el/init-python.el this is just the major mode --
;; no eglot registration, no init-treesit.el entry.

(use-package markdown-mode
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode))
  :custom
  ;; Fenced code blocks get the real major mode's syntax highlighting
  ;; (a ```python block reads like a .py buffer) instead of a flat color.
  (markdown-fontify-code-blocks-natively t)
  ;; The Markdown-mode equivalent of init-org.el's
  ;; org-hide-emphasis-markers: raw #/*/_ markup hides itself and
  ;; headers/emphasis render styled directly in the buffer.
  (markdown-hide-markup t))

(provide 'init-markdown)
;;; init-markdown.el ends here
