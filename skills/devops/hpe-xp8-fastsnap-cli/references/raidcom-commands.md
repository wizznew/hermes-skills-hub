# RAID Manager — Fast Snap Command Quick Reference

## Snapshot Lifecycle

| Status | Meaning | Action |
|--------|---------|--------|
| **SMPL** | Unpaired, no snapshot | Ready for new pair |
| **PAIR** | Active pair, tracking changes | Normal operation |
| **PSUP** | Split in progress | Wait → PSUS |
| **PSUS** | Split complete, snapshot readable | Mount S-VOL read-only |
| **PSUS(PD)** | Split in progress (pair delete) | Wait → SMPL |
| **RCPY** | Resync copy in progress | Wait → PAIR |
| **SMPP** | Pair deletion in progress | Wait → SMPL |

## Command Matrix

### Create

```bash
# Basic snapshot (auto MU#)
raidcom add snapshot -ldev_id <P-LDEV> -sdev_id <S-LDEV> -pool <Pool>

# With retention
raidcom add snapshot -ldev_id <P-LDEV> -sdev_id <S-LDEV> -pool <Pool> -retention 24

# With snapshot group + CTG
raidcom add snapshot -ldev_id <P-LDEV> <S-LDEV1> <S-LDEV2> -pool <Pool> \
  -snapshotgroup <Name> -snap_mode CTG -retention 24
```

### Query

```bash
# All snapshots on P-VOL
raidcom get snapshot -ldev_id <P-LDEV> -key details -format_time

# By snapshot group
raidcom get snapshot -snapshotgroup <Name> -key details -format_time

# Pool status
raidcom get pool -pool <Pool> -key status

# Snapshot tree
raidcom get snapshot -ldev_id <P-LDEV> -key snapshot_tree
```

### Modify

```bash
# Extend retention (cannot shorten!)
raidcom modify snapshot -ldev_id <P-LDEV> -mirror_id <MU#> \
  -snapshot_data renew_retention -retention 48

# Remove retention (make permanent)
raidcom modify snapshot -ldev_id <P-LDEV> -mirror_id <MU#> \
  -snapshot_data remove_retention

# Force pool garbage collection
raidcom modify snapshot -snapshot_data delete_garbage -pool <Pool>
```

### Delete

```bash
# Single snapshot by MU#
raidcom delete snapshot -ldev_id <P-LDEV> -mirror_id <MU#>

# All snapshots on P-VOL (including tree!)
raidcom delete snapshot -ldev_id <P-LDEV> -range tree

# All snapshots in group
raidcom delete snapshot -snapshotgroup <Name>
```

## Output Parsing Reference

### `raidcom get snapshot ... -key details -format_time`

```
LDEV(MU)    S-VOL INFO  LDEV-NO   ...  SPLT-TIME         RETENTION(H)  ...  STATUS
0x1010(0)   EX          0x2010    ...  2026/05/25 08:00   24           ...  PSUS
0x1010(1)   EX          0x2011    ...  2026/05/25 07:00    0           ...  PAIR
0x1010(2)   ALLOC       0x2012    ...  2026/05/24 23:00   12           ...  PSUS
```

| Column | Content | Extraction |
|--------|---------|-----------|
| 0 | `LDEV(MU)` | `awk '{print $1}'` then `sed 's/.*(//;s/)//'` for MU |
| 2 | S-VOL LDEV | `awk '{print $3}'` |
| 5-6 | SPLT-TIME | `awk '{print $6, $7}'` |
| 7 | RETENTION(H) | `awk '{print $8}'` |
| 9+ | STATUS | `awk '{print $NF}'` or match PAIR/PSUS/RCPY |

**Pitfall:** Column positions can shift between RAID Manager versions. Always verify with a live `raidcom get snapshot` run before writing parse scripts.

## Environment

```bash
# Required env vars (typically in ~/.profile or /etc/profile)
export HORCM_CONF=/etc/horcm/horcm.conf
export HORCM_INST=0        # HORCM instance number

# Start/stop HORCM daemon
horcmstart                  # start instance 0
horcmstart 1                # start instance 1
horcmshutdown               # stop instance 0
horcmshutdown 1              # stop instance 1

# Verify connectivity
raidqry -h                  # query storage status
raidcom get status          # check RAID Manager connectivity
```