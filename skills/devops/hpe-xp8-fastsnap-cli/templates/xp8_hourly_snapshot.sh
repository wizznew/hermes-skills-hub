#!/bin/bash
# ============================================================================
# HPE XP8 Fast Snap — Hourly Snapshot Rotation
# ============================================================================
# Creates hourly snapshots, maintains a rolling window of MAX_KEEP snapshots,
# and prunes the oldest when the count exceeds the limit.
#
# Usage:
#   1. Edit the CONFIG section below
#   2. Test: ./xp8_hourly_snapshot.sh | tee /tmp/test.log
#   3. Crontab: 0 * * * * /opt/xp8/xp8_hourly_snapshot.sh >> /var/log/xp8_snapshot.log 2>&1
#
# Dependencies: raidcom (RAID Manager CLI), awk, sed, sort, grep
# ============================================================================

set -euo pipefail

# --- CONFIG ---------------------------------------------------------------
P_LDEV="0x1010"                              # Primary volume LDEV
S_DEVICES="0x2010 0x2011 0x2012"            # S-VOL LDEV(s) for MU targets
POOL="PoolA"                                  # THP pool storing delta blocks
SNAP_GROUP="DailyBackup"                      # Snapshot group name
MAX_KEEP=10                                   # Max snapshots to retain
RETENTION=24                                  # Retention in hours per snapshot
LOG="/var/log/xp8_snapshot.log"              # Rotating log file
# --------------------------------------------------------------------------

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"; }
err() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $*" | tee -a "$LOG" >&2; }

# --- 1. Create new snapshot -----------------------------------------------
log "STEP 1: Creating new snapshot (GROUP=$SNAP_GROUP, RETENTION=${RETENTION}h)"

if ! raidcom add snapshot -ldev_id "$P_LDEV" $S_DEVICES \
   -pool "$POOL" -snapshotgroup "$SNAP_GROUP" -retention "$RETENTION" >> "$LOG" 2>&1; then
  err "Snapshot creation FAILED. Check RAID Manager connectivity."
  raidcom get status >> "$LOG" 2>&1
  exit 1
fi

sleep 2  # settle — PSUP → PSUS transition

# --- 2. List snapshots, parse columns ------------------------------------
log "STEP 2: Fetching snapshot list..."

RAW=$(raidcom get snapshot -snapshotgroup "$SNAP_GROUP" -key details -format_time 2>&1) || {
  err "get snapshot FAILED: $RAW"
  exit 1
}

# Parse MU#, LDEV, SPLT-TIME, STATUS
# Expected output format (header + data + blank line footer):
#   LDEV(MU)  S-VOL INFO  LDEV-NO   ...   SPLT-TIME          RETENTION(H)   ...   STATUS
#   0x1010(3) EX          0x2010    ...   2026/05/25 08:00   24              ...   PSUS

# Skip header (line 1-2), tail data rows, filter PSUS only, sort by SPLT-TIME (asc)
PARSED=$(echo "$RAW" | tail -n +3 | grep -v '^$' | grep "PSUS" | sort -k6)

# Count
COUNT=$(echo "$PARSED" | wc -l)
log "STEP 2: Found $COUNT PSUS snapshot(s)"

# --- 3. Prune if over limit -----------------------------------------------
if [ "$COUNT" -gt "$MAX_KEEP" ]; then
  PRUNE=$((COUNT - MAX_KEEP))
  log "STEP 3: Over limit ($COUNT > $MAX_KEEP). Pruning $PRUNE oldest..."
else
  log "STEP 3: Within limit ($COUNT <= $MAX_KEEP). No pruning required."
  log "DONE."
  exit 0
fi

# Extract oldest PRUNE rows
echo "$PARSED" | head -n "$PRUNE" | while read -r line; do
  # Column 0: LDEV(MU) — e.g. "0x1010(3)"
  LDEV_MU=$(echo "$line" | awk '{print $1}')
  MU=$(echo "$LDEV_MU" | sed 's/.*(//;s/)//')
  LDEV=$(echo "$LDEV_MU" | sed 's/(.*//')

  # Column 2: S-VOL LDEV number
  SDEV=$(echo "$line" | awk '{print $3}')

  # Column 6: SPLT-TIME
  SPLT=$(echo "$line" | awk '{print $6, $7}')

  log "  Deleting: LDEV=$LDEV, MU=$MU, SDEV=$SDEV, SPLIT=$SPLT"

  raidcom delete snapshot -ldev_id "$LDEV" -mirror_id "$MU" >> "$LOG" 2>&1 || {
    err "  FAILED to delete LDEV=$LDEV MU=$MU"
    continue
  }
done

# --- 4. Garbage collection -----------------------------------------------
log "STEP 4: Forcing pool garbage collection (POOL=$POOL)..."
raidcom modify snapshot -snapshot_data delete_garbage -pool "$POOL" >> "$LOG" 2>&1 || {
  err "  Garbage collection skipped or failed for pool $POOL"
}

log "DONE."
