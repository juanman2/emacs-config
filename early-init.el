;;; early-init.el --- Pre-package-system setup -*- lexical-binding: t; -*-

;; Emacs 30 loads this before init.el, before the package system and
;; UI are initialized, so keep it to startup-critical settings only.

;; Skip drawing chrome that init.el's own settings would immediately
;; tear down again; avoids a frame flash on startup.
(setq default-frame-alist
      '((menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (vertical-scroll-bars . nil)))
(setq inhibit-startup-screen t)

;; A larger GC threshold speeds up startup and package loading;
;; init.el lowers it back to a steady-state value once loading is done.
(setq gc-cons-threshold (* 64 1024 1024))

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(setq package-archive-priorities
      '(("gnu" . 3) ("nongnu" . 2) ("melpa" . 1)))

(setq native-comp-async-report-warnings-errors 'silent)

;;; early-init.el ends here
