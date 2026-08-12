;;; init-treesit.el --- Tree-sitter grammar bootstrap -*- lexical-binding: t; -*-

;; go-ts-mode/python-ts-mode need their grammars compiled once. This
;; fetches and builds them on first run instead of requiring a manual
;; M-x treesit-install-language-grammar per machine.
(setq treesit-language-source-alist
      '((go . ("https://github.com/tree-sitter/tree-sitter-go"))
        (python . ("https://github.com/tree-sitter/tree-sitter-python"))))

(dolist (lang '(go python))
  (unless (treesit-language-available-p lang)
    (treesit-install-language-grammar lang)))

(provide 'init-treesit)
;;; init-treesit.el ends here
