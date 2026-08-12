# CLAUDE.md — maintaining this Emacs config

This repo is a from-scratch rewrite (2026-08-12) of an ~8-year-old config
(the previous one lives at `juanman2/emacs.d`). The old config used elpy,
go-mode/godef, rtags/irony, auto-complete, and a dirtrack-hacked shell-mode
— all superseded now that the target is Emacs 30.2, which has eglot and
tree-sitter major modes built in.

## Scope

In scope: Go, Python, a real terminal, Mac keybindings, a low-eye-strain
theme/font, org-mode, Jupyter/ein notebooks.

Explicitly out of scope (was in the old config, dropped as unused):
C++/CMake (rtags, irony, cmake-mode). Add a `lisp/init-cc.el` module the
same way the others are built if a project needs it later — don't add it
speculatively.

## Layout

- `early-init.el` — runs before the package system and UI; only
  startup-critical settings (package archives, GC threshold, chrome).
- `init.el` — thin loader; `require`s each `lisp/init-*.el` module in
  order and does nothing else.
- `lisp/init-ui.el` — font (JetBrains Mono, falls back to Menlo),
  modus-vivendi theme, chrome.
- `lisp/init-keys.el` — Mac modifier keys (Command→Meta, Option untouched),
  trackpad scroll tuning.
- `lisp/init-completion.el` — vertico/orderless/marginalia/consult
  (minibuffer) + corfu/cape (in-buffer). Replaces helm + auto-complete.
- `lisp/init-treesit.el` — fetches/builds tree-sitter grammars for
  go-ts-mode/python-ts-mode on first run.
- `lisp/init-eglot.el` — shared LSP client config; per-language server
  registration lives in the language's own module.
- `lisp/init-go.el` — go-ts-mode + gopls, format+organize-imports on save.
- `lisp/init-python.el` — python-ts-mode + pyright, `pet` for venv
  detection.
- `lisp/init-shell.el` — vterm + multi-vterm.
- `lisp/init-org.el`, `lisp/init-jupyter.el` — org-mode and ein/Jupyter.

## Conventions

- Every module ends with `(provide 'init-X)`; `init.el` is the only file
  that `require`s them, in a fixed order (UI → keys → completion →
  tree-sitter → eglot → languages → shell → org/jupyter). Keep new modules
  independent of each other — a module shouldn't reach into another's
  internals.
- Package manager is built-in `package.el` + `use-package`
  (`use-package-always-ensure t` in `init.el`), pulling from GNU ELPA /
  NonGNU ELPA / MELPA. No straight.el/elpaca — deliberately, to avoid a
  second bootstrapping layer on top of what Emacs already ships.
- Prefer a built-in Emacs 29/30 facility over a package when one exists
  (this is why eglot/tree-sitter modes were chosen over lsp-mode/go-mode
  here). Only reach for a package when the built-in doesn't cover the
  need (e.g. vterm — no built-in gives a real terminal; pet — no built-in
  does venv detection).
- No comments explaining *what* a form does — only *why*, when it's
  non-obvious (a Mac-specific quirk, a version constraint, a workaround).

## External binaries this config assumes are on PATH

These aren't installed by Emacs — install them separately, per-machine.
Prefer Homebrew over the language-native installers below when there's a
formula for it — it doesn't require a Go/Node toolchain just to get one
binary, which is how these were actually installed on the dev machine:

- `gopls` (Go) — `brew install gopls`, or `go install
  golang.org/x/tools/gopls@latest` if you already have a Go toolchain
- `pyright` (Python) — `brew install pyright` (pulls in Node as a
  dependency), or `npm install -g pyright` if you already have Node
- `jupyter` + `jupyter-console` (notebooks/console) — `brew install
  jupyterlab`, or `pip install jupyter` into a venv
- `cmake` + GNU libtool — one-time, to compile vterm's native module on
  first package install: `brew install cmake libtool`. libvterm's build
  script invokes `glibtool` specifically; macOS's own `/usr/bin/libtool`
  is Apple's linker tool of the same name, not GNU Libtool, and does
  *not* satisfy this — the build fails with `glibtool: No such file or
  directory` until the Homebrew one is installed.

## Shell-side setup this config needs: emacs-config.sh

`emacs-config.sh` (repo root) holds everything that has to live in the
shell rather than in Elisp — deliberately kept out of `~/.zshrc` itself
(source it from there instead) so shell config doesn't end up split
between two repos once a separate dotfiles/shell-config repo exists.
Currently it covers:

- the `emacs`/`emacs-term` daemon-launcher functions (see "Get a
  GUI-capable Emacs on macOS" in `README.md`)
- vterm's directory-tracking integration, below

Without the vterm piece, `default-directory` in a vterm buffer never
follows the shell's real cwd — `C-x C-f` after `cd`-ing to a
subdirectory opens relative to wherever the buffer started, not where
the shell actually is. Not a bug in this config; vterm needs an
explicit opt-in on the shell side (vterm ships an equivalent for
bash/fish too, under the package's own `etc/` dir):

```sh
if [[ "$INSIDE_EMACS" = 'vterm' ]] \
    && [[ -n ${EMACS_VTERM_PATH} ]] \
    && [[ -f ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh ]]; then
        source ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh
fi
```

`EMACS_VTERM_PATH` is set by vterm.el itself (to wherever the currently
loaded vterm package lives) whenever it spawns a shell, so this doesn't
need updating across package upgrades. The sourced script hooks zsh's
`chpwd`/prompt machinery to emit an OSC escape sequence vterm parses to
sync `default-directory` — and the host too, so it works over SSH via
TRAMP. This replaces the old config's PS1-regexp `dirtrack-mode` hack
entirely; don't reintroduce that, vterm's mechanism is more robust
(protocol-based, not prompt-regexp parsing) and works remotely.

## Testing a change

`emacs --batch -l init.el --eval '(kill-emacs)'` catches load-order and
syntax errors without a display, but it can't install packages that
aren't already present (`package-install` needs an interactive first run
per machine) and can't verify a font/theme visually — do that in a real
frame. There's no other test suite here; this is a config, not a library.

## Adding support for a new language

Use the `add-language-mode` skill (`.claude/skills/add-language-mode/`) —
it scaffolds a new `lisp/init-<lang>.el` following the same eglot +
tree-sitter pattern as Go/Python, and wires it into `init.el`.
