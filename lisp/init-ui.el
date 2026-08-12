;;; init-ui.el --- Fonts, theme, and chrome -*- lexical-binding: t; -*-

(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(setq ring-bell-function 'ignore)

(line-number-mode 1)
(column-number-mode 1)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(setq-default indent-tabs-mode nil)

(defun jt/set-default-font ()
  "Use JetBrains Mono if installed, else fall back to system Menlo."
  (set-face-attribute
   'default nil :font
   (if (find-font (font-spec :name "JetBrains Mono"))
       "JetBrains Mono-14"
     "Menlo-14")))
(jt/set-default-font)

;; modus-vivendi ships with Emacs 28+ and is tuned for WCAG AA
;; contrast, i.e. legible without the eye strain of a high-contrast
;; or oversaturated theme.
(load-theme 'modus-vivendi t)

(provide 'init-ui)
;;; init-ui.el ends here
