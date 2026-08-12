#!/usr/bin/env bash
# Symlinks ~/.emacs.d to this repo. Safe to re-run: a no-op if already
# linked correctly, and backs up (never deletes) anything unexpected
# found at ~/.emacs.d rather than overwriting it.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.emacs.d"

if [ ! -f "$REPO_DIR/init.el" ]; then
  echo "error: $REPO_DIR doesn't look like the emacs-config repo (no init.el)" >&2
  exit 1
fi

if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$REPO_DIR" ]; then
  echo "OK   $TARGET -> $REPO_DIR (already linked)"
elif [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
  BACKUP="${TARGET}.bak.$(date +%Y%m%d%H%M%S)"
  echo "Backing up existing $TARGET -> $BACKUP"
  mv "$TARGET" "$BACKUP"
  ln -s "$REPO_DIR" "$TARGET"
  echo "OK   $TARGET -> $REPO_DIR  (previous contents saved to $BACKUP)"
else
  ln -s "$REPO_DIR" "$TARGET"
  echo "OK   $TARGET -> $REPO_DIR"
fi

cat <<EOF

Next steps (not done by this script):
  - Launch Emacs once interactively so use-package can install packages.
  - Source emacs-config.sh from your shell rc -- see README.md's Install
    section for the exact snippet. Not a symlink target: it's meant to
    be sourced, not linked, so it stays governed by the shell's own
    startup sequence.
EOF
