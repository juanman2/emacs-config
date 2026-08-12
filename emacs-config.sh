# Shell-side config for this Emacs setup. Sourced from ~/.zshrc (or
# any POSIX-ish shell rc) rather than pasted in directly, so this repo
# stays the single source of truth for anything Emacs-related.

# Launch a native Cocoa GUI frame from the terminal, backed by a
# long-lived daemon started on demand — Cmd-key combos never reach
# Emacs when it's inside a terminal emulator, only Control/Escape
# sequences do, so a real GUI frame is required for Mac keybindings.
# The Cask build (/Applications/Emacs.app) isn't brew-services-managed,
# so the daemon is started directly rather than via `brew services`.
emacs() {
  if ! emacsclient -e t &>/dev/null; then
    command emacs --daemon &>/dev/null
    for _ in {1..40}; do
      emacsclient -e t &>/dev/null && break
      sleep 0.25
    done
  fi
  emacsclient -c -n "$@"
}
alias emacs-term='command emacs -nw'

# vterm's own shell integration: syncs default-directory (and host, so
# it works transparently over SSH via TRAMP) with the shell's real cwd
# on every prompt, via an escape-sequence protocol -- not the PS1-regex
# dirtrack hack the old shell-mode.el needed. EMACS_VTERM_PATH is set
# by vterm.el itself to point at whichever vterm package version is
# currently loaded, so this doesn't need updating across upgrades.
if [[ "$INSIDE_EMACS" = 'vterm' ]] \
    && [[ -n ${EMACS_VTERM_PATH} ]] \
    && [[ -f ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh ]]; then
        source ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh
fi
