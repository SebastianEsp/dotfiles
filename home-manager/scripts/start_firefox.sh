#!/usr/bin/env sh

# Remove stale SQLite shared-memory and profile lock files left by an unclean
# shutdown. The .sqlite-shm files are always safe to delete; SQLite recreates
# them from the .sqlite-wal on next open. Stale lock symlinks are also safe to
# remove since Firefox recreates them on start.
find "$HOME/.mozilla/firefox" -maxdepth 2 \( -name "*.sqlite-shm" -o -name "lock" \) -delete
