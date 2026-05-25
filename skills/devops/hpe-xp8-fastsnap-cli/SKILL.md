---
name: hpe-xp8-fastsnap-cli
description: HPE XP8 Fast Snap CLI operations — snapshot lifecycle, rotation, retention, pool management, parsing, and automation scripts using raidcom commands.
---

# HPE XP8 Fast Snap CLI

## When to Load

User mentions:
- Fast Snap, snapshot, snapshot group
- `raidcom` snapshot commands
- Snapshot rotation, retention, pool reclamation
- Backup automation with XP8
- CLI parsing of `raidcom get snapshot` output

## Key Concepts

| Term | Meaning |
|------|---------|
| **P-VOL** | Primary Volume (source data) |
| **S-VOL / V-VOL** | Secondary (snapshot target, pool-backed virtual volume) |
| **MU#** | Mirror Unit — unique ID per snapshot generation (0–1023) |
| **Snapshot Group** | Named collection of snapshots managed as a unit |
| **Pool** | THP pool that stores snapshot delta blocks |
| **PAIR** | Snapshot active, tracking changes |
| **PSUS** | Snapshot split, point-in-time view readable |
| **SMPL** | Unpaired, no snapshot |
| **PSUP** | Split in progress |
| **RCPY** | Resync copy in progress |
| **MU Shared** | Multiple MUs share delta data → prevents pool reclamation until all consuming snapshots deleted |

## Commands

### Create Snapshot

```bash
# Basic — auto-assigns MU
raidcom add snapshot -ldev_id <P-VOL_LDEV> -sdev_id <S-VOL_LDEV> -pool <PoolName>

# With retention (hours)
raidcom add snapshot -ldev_id <P-VOL_LDEV> -sdev_id <S-VOL_LDEV> -pool <PoolName> -retention 24

# With snapshot group + consistency group
raidcom add snapshot -ldev_id <P-VOL_LDEV> <S-VOL_LDEV> -pool <PoolName> \
  -snapshotgroup <GroupName> -snap_mode CTG -retention 24

# Multiple S-VOLs (up to disk-quota per pool, usually 1024 per P-VOL)
raidcom add snapshot -ldev_id 0x1010 0x2010 0x2011 0x2012 -pool PoolA -snapshotgroup SnGrpA
```

### List / Inspect

```bash
# All snapshots on a P-VOL
raidcom get snapshot -ldev_id <P-VOL_LDEV> -key details -format_time

# Filter by snapshot group
raidcom get snapshot -snapshotgroup <GroupName> -key details -format_time

# Filter by pool
raidcom get snapshot -pool <PoolName> -key details -format_time

# Tree view (parent-child relationships)
raidcom get snapshot -ldev_id <P-VOL_LDEV> -key snapshot_tree
```

### Delete Snapshot

```bash
# By P-VOL LDEV + MU number
raidcom delete snapshot -ldev_id <P-VOL_LDEV> -mirror_id <MU#>

# Delete entire snapshot tree (all MUs on this P-VOL)
raidcom delete snapshot -ldev_id <P-VOL_LDEV> -range tree

# Delete all snapshots in snapshot group
raidcom delete snapshot -snapshotgroup <GroupName>

# Force pool garbage collection
raidcom modify snapshot -snapshot_data delete_garbage -ldev_id <P-VOL_LDEV>
```

### Modify

```bash
# Extend retention
raidcom modify snapshot -ldev_id <P-VOL_LDEV> -mirror_id <MU#> \
  -snapshot_data renew_retention -retention 48

# Bulk — extend retention for all snapshots in group  
raidcom modify snapshot -snapshotgroup <GroupName> \
  -snapshot_data renew_retention -retention 72

# Remove retention (permanent snapshot — no auto-delete)
raidcom modify snapshot -ldev_id <P-VOL_LDEV> -mirror_id <MU#> \
  -snapshot_data remove_retention

# Reclaim pool space
raidcom modify snapshot -snapshot_data delete_garbage -pool <PoolName>
```

### Snapshot Group Management

```bash
# Create group (one-time setup)
raidcom add snapshot -ldev_id <P-VOL_LDEV> <S-VOL_LDEV> -pool <PoolName> \
  -snapshotgroup DailyBackup -snap_mode CTG -retention 24

# List groups
raidcom get snapshot -snapshotgroup DailyBackup -key details -format_time

# Delete group (deletes ALL snapshots in it)
raidcom delete snapshot -snapshotgroup DailyBackup
```

## Automation Pattern: Snapshot Rotation

### Rotation Logic

```
1. CREATE new snapshot with -retention <hours>
2. COUNT existing snapshots
3. IF count > MAX_KEEP → sort by SPLT-TIME (oldest first)
4. DELETE oldest (MU# identified from column parsing)
5. LOG all actions with timestamp
```

### Parsing `raidcom get snapshot` Output

**Output format (with `-format_time`):**

```
LDEV(MU) S-VOL-INFO LDEV-NO ... SPLT-TIME         RETENTION(H) ... STATUS
0x1010    EX         0x2010   ... 2026/05/25 08:00     24      ... PAIR
0x1010    EX         0x2011   ... 2026/05/25 07:00      0      ... PSUS
0x1010    EX         0x2012   ... 2026/05/24 23:00     12      ... PSUS
```

**Column positions (0-indexed):**
- Column 0: `LDEV(MU)` — e.g. `0x1010(0)` where MU# = `0`
- Column 1: `S-VOL-INFO` — EX/SI/ALLOC
- Column 2: `LDEV-NO` — S-VOL LDEV number
- Column 5: `SPLT-TIME` — split timestamp
- Column 6: `RETENTION(H)` — remaining hours
- Column 8+: `STATUS` — PAIR / PSUS / RCPY / etc.

**Parsing rules from experience:**
- **DO NOT** use `head -n -1` (may drop data rows when header count varies)
- **SAFER** pattern: `tail -n +3 | grep -v '^$'` to skip header + footer and empty lines
- MU# is embedded in `LDEV(MU)` column — extract with `sed` or `awk`
- Always run `raidcom get snapshot -format_time` once and visually verify column positions before writing parse scripts

### Minimal Rotation Script

```bash
#!/bin/bash
# Template: hourly snapshot rotation
# Customize: P_LDEV, TARGET, MAX_KEEP, POOL, SNAP_GROUP
set -euo pipefail

P_LDEV="0x1010"
TARGET="0x2010 0x2011 0x2012"
SNAP_GROUP="DailyBackup"
POOL="PoolA"
MAX_KEEP=10
LOG="/var/log/xp8_snapshot.log"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"; }

# 1. Create new snapshot
log "Creating snapshot..."
raidcom add snapshot -ldev_id "$P_LDEV" $TARGET -pool "$POOL" \
  -snapshotgroup "$SNAP_GROUP" -retention 24 >> "$LOG" 2>&1

# 2. List sorted by SPLT-TIME (oldest first)
OUT=$(raidcom get snapshot -snapshotgroup "$SNAP_GROUP" -key details -format_time 2>&1)

# 3. Count PSUS snapshots
COUNT=$(echo "$OUT" | tail -n +3 | grep "PSUS" | wc -l)
log "Snapshot count (PSUS): $COUNT"

# 4. Prune if over limit
if [ "$COUNT" -gt "$MAX_KEEP" ]; then
  PRUNE=$((COUNT - MAX_KEEP))
  log "Pruning $PRUNE snapshot(s)..."
  
  echo "$OUT" | tail -n +3 | grep "PSUS" | sort -k6 \
    | head -n "$PRUNE" \
    | awk '{print $1, $3}' \
    | while read ldev_mu sdev; do
        MU=$(echo "$ldev_mu" | sed 's/.*(//;s/)//')
        LV=$(echo "$ldev_mu" | sed 's/(.*//')
        raidcom delete snapshot -ldev_id "$LV" -mirror_id "$MU" >> "$LOG" 2>&1
        log "Deleted snapshot LDEV=$LV MU=$MU"
      done
fi
```

## Retention Rules

| Rule | Detail |
|------|--------|
| Max retention | 99,999 hours (~11 years) |
| Shorten not allowed | `renew_retention` rejected if new value < existing |
| Remove retention | `-snapshot_data remove_retention` → permanent, no auto-delete |
| Retention display | `-format_time` shows remaining hours; `0` = permanent / expired |
| Auto-delete | Snapshots with expired retention auto-deleted by storage |

## Pool Management

```bash
# Check pool usage
raidcom get pool -pool <PoolName>

# Force immediate garbage collection
raidcom modify snapshot -snapshot_data delete_garbage -pool <PoolName>

# Check snapshot count per pool
raidcom get snapshot -pool <PoolName> | tail -n +3 | wc -l
```

## Limits

| Item | Limit |
|------|-------|
| Max snapshots per P-VOL | 1,024 |
| Max snapshots per snapshot group | 32,768 |
| Max snapshot groups | 64,000+ (depends on license) |
| Max CTG IDs (non-HA) | 256 (0-255) |
| Max CTG IDs (HA) | 1,024 |
| Max pools | 256 (non-HA) / 512 (HA) |

## Pitfalls

- **MU# extraction**: MU# is inside `LDEV(MU)` column like `0x1010(3)`. Use `sed 's/.*(//;s/)//'` to extract, NOT field splitting.
- **PSUS(PD)**: Volume enters transient PSUS(PD) state before PSUS. Pairsplit in PD means the data's still being flushed—can't mount yet. Wait.
- **RCPY status**: Don't delete a snapshot in RCPY (resync) — wait for PSUS.
- **Pool reclamation**: `delete garbage` only frees blocks NOT shared by any remaining MU. One MU pointing to an old block blocks reclamation.
- **Shared MUs**: Multiple snapshots may share delta blocks. Deleting the first doesn't free pool space immediately. Run `raidcom delete snapshot -snapshot_data delete_garbage` afterwards.
- **Sort key**: `sort -k6` on `-format_time` output — confirm the column index with a real run first.
- **Expired retention**: Snapshots stay readable until auto-deleted by storage. The `-retention` is a time-to-live, not an immediate deletion timer.
- **`-range tree`**: Deletes ALL MUs on the P-VOL including active PAIR ones. Use with extreme caution.

## Verify Status

```bash
# Check specific snapshot pair
raidcom get snapshot -ldev_id 0x1010 -mirror_id 0 -key details -format_time

# Expected output for healthy snapshot:
# LDEV(MU) S-VOL INFO ... STATUS
# 0x1010(0) EX ... PSUS

# Pool health
raidcom get pool -pool PoolA -key status
```

## Reference Documents

- Fast Snap User Guide (HPEDP00003194ENUS)
- RAID Manager Reference Guide (HPEDP00003607ENUS)
- RAID Manager Installation & Configuration Guide (HPEDP00003165ENUS)
