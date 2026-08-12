;;; init-keys.el --- Mac keyboard mapping -*- lexical-binding: t; -*-

;; Command as Meta matches every Emacs keybinding convention (M-x,
;; M-w, ...); Option is left alone so it still types accented and
;; special characters instead of doubling as another modifier.
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;; Trackpad scrolling on macOS sends many small events; without this
;; each one re-accelerates and scrolling feels jumpy.
(setq mouse-wheel-progressive-speed nil)
(setq scroll-conservatively 101)

(provide 'init-keys)
;;; init-keys.el ends here
