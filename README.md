# emacs-config

A from-scratch Emacs config for Go, Python, org-mode, and Jupyter work,
targeting Emacs 30+. Rewritten 2026-08-12 to replace an 8-year-old setup
(`juanman2/emacs.d`) built around elpy, go-mode/godef, rtags/irony, and
helm — all superseded now that eglot and tree-sitter major modes ship
with Emacs itself.

See `CLAUDE.md` for the module layout, conventions, and how to extend
this config (including a Claude Code skill for adding new languages).

## Install

```sh
git clone git@github.com:juanman2/emacs-config.git ~/.emacs.d
```

Then launch Emacs once interactively (not `--batch`) so `use-package`
can install everything from GNU ELPA/NonGNU ELPA/MELPA.

### External binaries

Install separately, per machine — see "External binaries" in `CLAUDE.md`
for the full list (`gopls`, `pyright`, `jupyter`, `cmake`).
