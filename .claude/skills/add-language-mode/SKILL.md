---
name: add-language-mode
description: Scaffold eglot + tree-sitter support for a new language in this Emacs config, following the pattern established by lisp/init-go.el and lisp/init-python.el. Use whenever the user asks to add a new language/major mode to this config.
---

# Adding a new language mode

This config's Go and Python support (`lisp/init-go.el`, `lisp/init-python.el`)
follow one pattern: a built-in `-ts-mode` (tree-sitter major mode) bound to
its file extension, an eglot server registration, and format-on-save. Follow
that same shape for a new language rather than introducing a different
mechanism (no lsp-mode, no a different completion/format story per
language) — see `CLAUDE.md` for why.

## Steps

1. Check whether Emacs ships a `<lang>-ts-mode` built in
   (`M-x describe-function <lang>-ts-mode`). If yes, use it. If the
   language has no tree-sitter mode, use the traditional major mode
   instead (e.g. `<lang>-mode`) — don't force tree-sitter where Emacs
   doesn't support it.
2. Add the grammar source to `treesit-language-source-alist` in
   `lisp/init-treesit.el` (skip if not using a `-ts-mode`).
3. Create `lisp/init-<lang>.el` modeled on `lisp/init-go.el`:
   - `auto-mode-alist` entry for the file extension
   - `eglot-server-programs` entry for the language server, added via
     `with-eval-after-load 'eglot`
   - a `before-save-hook` for `eglot-format-buffer` if the language
     server supports formatting
   - end with `(provide 'init-<lang>)`
4. Add `(require 'init-<lang>)` to `init.el`, after `init-eglot` and
   alongside the other language modules.
5. Add the language server binary to the "External binaries" list in
   `CLAUDE.md`, with its install command.
6. Smoke-test: `emacs --batch -l init.el --eval '(kill-emacs)'` from the
   repo root should exit cleanly.

## Known languages (verified, so step 1/2/5 don't need re-research)

| Language | `-ts-mode` (built-in, Emacs 29+) | Grammar source for `init-treesit.el` | LSP server | Install | Gotcha |
|---|---|---|---|---|---|
| C++ | `c++-ts-mode` | `https://github.com/tree-sitter/tree-sitter-cpp` | `clangd` | `brew install llvm` | `llvm` is keg-only — not on PATH by default. Either add `$(brew --prefix llvm)/bin` to PATH or use the absolute path in the `eglot-server-programs` entry. |
| Rust | `rust-ts-mode` | `https://github.com/tree-sitter/tree-sitter-rust` | `rust-analyzer` | `brew install rust-analyzer` | none |
| Java | `java-ts-mode` | `https://github.com/tree-sitter/tree-sitter-java` | `jdtls` | `brew install jdtls` | jdtls needs a per-project `--data <workspace-dir>` argument, unlike the other three servers here — a plain `("jdtls")` entry in `eglot-server-programs` won't work. Use eglot's function-valued "contact" form (see the `eglot-server-programs` docstring, `C-h v`) to compute a per-project data dir, e.g. under `~/.cache/jdtls/<project-name>`. |

If a fourth language comes up that isn't in this table, verify with
`brew search <lsp-server-name>` before writing the install command down
— don't guess a formula name.

## What not to do

- Don't add a language-specific completion or minibuffer package — the
  existing corfu/vertico/consult stack in `lisp/init-completion.el`
  already covers every mode.
- Don't reach for lsp-mode even if a blog post recommends it for this
  language — eglot is the one LSP client this config uses.
