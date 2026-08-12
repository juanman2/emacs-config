---
description: Check this Emacs config for load errors, missing external binaries, and outdated packages.
---

Run these checks against the current directory (this repo) and report a
short pass/fail summary, one line per check:

1. **Load test**: run
   `emacs --batch -q -l early-init.el -l init.el --eval '(kill-emacs)'`
   from the repo root and check it exits 0 with no `Error`/`Warning` in
   stderr. This won't install missing packages — if it fails on a
   `(require ...)`, that's expected on a machine that's never run this
   config interactively; note it but don't treat it as a real failure.
2. **External binaries**: for each binary listed under "External
   binaries" in `CLAUDE.md` (`gopls`, `pyright`, `jupyter`, `cmake`),
   check `command -v <binary>` and report which are missing.
3. **Font**: check whether "JetBrains Mono" resolves via
   `fc-list | grep -i "jetbrains mono"` (or the macOS equivalent) and
   report if it's missing — `lisp/init-ui.el` will silently fall back to
   Menlo if so, which is a real font mismatch, not an error, so flag it
   as informational.
4. **Outdated packages**: if Emacs has run interactively before (check
   for `~/.emacs.d/elpa` or this repo's package dir), report whether
   `package-archive-contents` looks stale — suggest running
   `/emacs-update` if so, don't run it yourself.

Report results as a short checklist, not prose. Don't modify any files.
