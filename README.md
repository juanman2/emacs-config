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
git clone git@github.com:juanman2/emacs-config.git ~/src/emacs-config
~/src/emacs-config/install.sh
```

The repo lives at `~/src/emacs-config`, not `~/.emacs.d` directly —
`install.sh` symlinks `~/.emacs.d` to it (backing up, never
overwriting, anything unexpected already there) so the repo can be
cloned wherever you keep source checkouts, not forced into
`~/.emacs.d`. Safe to re-run any time; it's a no-op if already linked.

Then launch Emacs once interactively (not `--batch`) so `use-package`
can install everything from GNU ELPA/NonGNU ELPA/MELPA.

### Get a GUI-capable Emacs on macOS

`brew install emacs` (the core Homebrew formula) is compiled
`--without-ns` — a console-only build with no native window support at
all. It'll run, but `mac-command-modifier`/`ns-command-modifier` (see
`lisp/init-keys.el`) do nothing on it, and running it inside a terminal
emulator can't work regardless — Cmd-key combos never reach a program
hosted in a terminal, only Control/Escape sequences pass through a tty.

Use the official Cask build instead: `brew install --cask emacs`
(installs `/Applications/Emacs.app`, and links `emacs`/`emacsclient`
into `/opt/homebrew/bin`). If a console-only `emacs` formula is already
installed, `brew uninstall emacs` first so the Cask's binaries link
cleanly instead of being skipped.

For working from a terminal day-to-day, run Emacs as a daemon and open
GUI frames against it with `emacsclient -c`, rather than running a
terminal-hosted session — that's the only way Mac keybindings apply.
`emacs-config.sh` in this repo does that transparently (an `emacs`
function that starts the daemon on first use, plus vterm's directory
tracking) — source it from `~/.zshrc` rather than pasting its contents
in directly, so this repo stays the one place that needs updating:

```sh
if [ -e ~/src/emacs-config/emacs-config.sh ]; then
  source ~/src/emacs-config/emacs-config.sh
fi
```

### External binaries

Install separately, per machine — see "External binaries" in `CLAUDE.md`
for the full list (`gopls`, `pyright`, `jupyter`, `cmake`).
