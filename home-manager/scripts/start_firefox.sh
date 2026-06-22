#!/usr/bin/env sh

FIREFOX_DIR="$HOME/.mozilla/firefox"

# Checkpoint all WAL files before Firefox starts. Stale WAL files from an unclean
# shutdown require SQLite WAL recovery on next open, which needs an exclusive lock.
# Three Firefox instances starting in parallel all hit this at once, causing
# SQLITE_BUSY and the "bookmarks and history system will not be functional" error.
# Checkpointing here writes WAL data into the main DB and removes the WAL file,
# so Firefox opens each database cleanly with no recovery needed.
python3 - "$FIREFOX_DIR" <<'EOF'
import sqlite3, glob, os, sys

fdir = sys.argv[1]
for wal in glob.glob(os.path.join(fdir, "*", "*.sqlite-wal")):
    db = wal[:-4]
    if os.path.exists(db):
        try:
            with sqlite3.connect(db) as conn:
                conn.execute("PRAGMA wal_checkpoint(TRUNCATE)")
        except Exception as e:
            print(f"warning: checkpoint failed for {db}: {e}", file=sys.stderr)
    for suffix in (".sqlite-wal", ".sqlite-shm"):
        try:
            os.remove(db + suffix)
        except FileNotFoundError:
            pass

for lock in glob.glob(os.path.join(fdir, "*", "lock")):
    try:
        os.remove(lock)
    except OSError:
        pass
EOF

