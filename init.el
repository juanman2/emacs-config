;;; init.el --- Entry point -*- lexical-binding: t; -*-

;; Rewritten 2026-08-12 to replace an ~8-year-old config (elpy,
;; go-mode/godef, rtags/irony, auto-complete, helm) with Emacs 30
;; built-ins (eglot, tree-sitter modes) plus a small modern package
;; set. See CLAUDE.md for the module layout and how to extend it.

(setq default-directory "~/src/")

(require 'package)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'init-ui)
(require 'init-keys)
(require 'init-completion)
(require 'init-treesit)
(require 'init-eglot)
(require 'init-go)
(require 'init-python)
(require 'init-shell)
(require 'init-org)
(require 'init-jupyter)

(server-start)

;; Steady-state GC threshold; early-init.el's larger value was only
;; to speed up the package/module loading above.
(setq gc-cons-threshold (* 16 1024 1024))

(custom-set-variables
 '(custom-safe-themes t))
(custom-set-faces)

;;; init.el ends here
