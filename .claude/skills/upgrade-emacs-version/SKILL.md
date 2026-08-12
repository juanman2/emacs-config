---
name: upgrade-emacs-version
description: Bump this config to a new Emacs release (Cask build) and verify nothing broke. Use whenever the user asks to upgrade/update Emacs itself, or asks what a new Emacs release changes for this config.
---

# Upgrading Emacs

This config targets the Cask build specifically — see "Get a
GUI-capable Emacs on macOS" in `README.md` for why (the core Homebrew
formula has no GUI support at all, `--without-ns`). Upgrading means
upgrading that Cask, then checking the four things a new Emacs release
can actually break here.

## Steps

1. **Upgrade the Cask**: `brew upgrade --cask emacs`. Then restart the
   daemon on the new binary: `emacsclient -e '(kill-emacs)'` (or just
   quit any running frame), then `command emacs --daemon`. Confirm the
   version: `emacs --version`.
2. **Re-run the smoke test** from `CLAUDE.md`'s "Testing a change"
   section (`emacs --batch -l early-init.el -l init.el --eval
   '(kill-emacs)'`) — catches load-order/API breakage fast, before
   touching anything interactive.
3. **Check for breaking changes** in the areas this config actually
   depends on — grep the new version's NEWS file rather than reading it
   end to end:
   ```sh
   grep -A3 -iE "treesit|eglot|use-package|python-ts-mode|go-ts-mode|org " \
     "$(brew --prefix)/opt/emacs-app/../Caskroom/emacs-app/*/Emacs.app/Contents/Resources/etc/NEWS" 2>/dev/null \
     || find /Applications/Emacs.app -iname "NEWS*" -exec grep -A3 -iE "treesit|eglot|use-package" {} \;
   ```
   Only investigate further if something in that output actually
   touches a symbol this config uses (`lisp/*.el` — grep those for the
   changed name to confirm before "fixing" anything speculative).
4. **Tree-sitter grammars**: `tree-sitter/` (gitignored, rebuilt
   per-machine) holds compiled grammar `.dylib`s. A major Emacs bump
   occasionally changes the tree-sitter ABI it expects; if `init-go.el`
   or `init-python.el` buffers error on open post-upgrade, delete
   `~/.emacs.d/tree-sitter/` and let `lisp/init-treesit.el` rebuild it
   (happens automatically on next `init.el` load).
5. **vterm's native module**: the Emacs module ABI is very stable —
   don't proactively recompile. Only if `vterm` buffers start erroring
   on open, rebuild it (`cd
   ~/.emacs.d/elpa/vterm-*/build && cmake --build .`, same as the
   original build in `CLAUDE.md`'s libtool troubleshooting note).
6. **Only if raising the floor version deliberately** (not just testing
   a newer release while staying compatible with the current floor):
   update "targeting Emacs 30+" in `README.md` and the `Emacs 30.2`
   references in `CLAUDE.md`.
7. Commit and push — even a no-op verification is worth a commit
   message noting the version tested against, so `git log` answers
   "when did we last confirm this works" without re-deriving it.

## What not to do

- Don't touch package versions as part of this — that's `/emacs-update`
  (a separate, independent axis: Emacs version vs. MELPA package
  versions don't move together).
- Don't add a compatibility shim for a deprecated function this config
  doesn't call — only fix what step 3 actually surfaces as in-use.
