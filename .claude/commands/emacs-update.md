---
description: Refresh package archives and upgrade all installed packages for this Emacs config.
---

Upgrade this config's packages, then verify nothing broke:

1. Run, from the repo root:
   ```
   emacs --batch -q -l early-init.el \
     --eval '(progn (package-initialize) (package-refresh-contents) (package-upgrade-all t))'
   ```
2. Re-run the load test: `emacs --batch -q -l early-init.el -l init.el --eval '(kill-emacs)'`.
   If it now errors where it didn't before, a package upgrade broke
   something — report which `require` failed and stop; don't try to
   auto-fix a package API change.
3. Tell the user to launch Emacs interactively once to confirm nothing
   looks wrong before they commit — this command doesn't do that for
   them.
4. This repo doesn't pin package versions (plain `package.el`, no
   lockfile), so there's nothing to commit after a successful upgrade
   unless `init.el`/`lisp/*.el` themselves changed to accommodate an API
   change — only stage those files if so.
