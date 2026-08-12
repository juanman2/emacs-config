;;; init-jupyter.el --- Jupyter/ein notebooks -*- lexical-binding: t; -*-

;; Requires `jupyter` on PATH (pip install jupyter) for both ein
;; notebooks and the IPython console below.

(use-package ein
  :commands (ein:run ein:login))

;; An IPython console (via jupyter) as the interactive Python shell,
;; so python-shell buffers behave like ein notebook kernels.
(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(with-eval-after-load 'python
  (add-to-list 'python-shell-completion-native-disabled-interpreters "jupyter"))

(provide 'init-jupyter)
;;; init-jupyter.el ends here
