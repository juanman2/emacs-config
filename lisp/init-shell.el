;;; init-shell.el --- Terminal -*- lexical-binding: t; -*-

;; vterm is a real terminal emulator (full-screen apps, correct cwd
;; tracking) and replaces the old dirtrack-hack shell-mode setup,
;; which broke whenever the PS1 regexp didn't match. Its native
;; module needs cmake + libtool at install time to compile.

(use-package vterm
  :commands vterm
  :custom
  (vterm-max-scrollback 10000)
  (vterm-timer-delay 0.01))

(use-package multi-vterm
  :commands (multi-vterm multi-vterm-project)
  :bind (("C-c t" . multi-vterm)
         ("C-c T" . multi-vterm-project)))

(provide 'init-shell)
;;; init-shell.el ends here
