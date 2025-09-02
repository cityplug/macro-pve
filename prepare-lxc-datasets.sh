#!/bin/bash
# Script to prepare ZFS datasets for unprivileged LXCs on Proxmox
# Adjust POOL name if your pool is not "tank"

POOL="tank"

# UID/GID mapping
# root inside container (uid 0) = 100000 on host
# user inside container (uid 1000) = 101000 on host
ROOT_UID=100000
ROOT_GID=100000
USER_UID=101000
USER_GID=101000

# List of datasets
DATASETS=("appdata" "library" "utilities" "compute" "backup")

echo ">>> Preparing datasets in pool: $POOL"

for DS in "${DATASETS[@]}"; do
    FULLPATH="/$POOL/$DS"

    if [ -d "$FULLPATH" ]; then
        echo " - Setting permissions for $FULLPATH"
        
        # Root-level control
        chown $ROOT_UID:$ROOT_GID "$FULLPATH"

        # App-specific subfolders (for UID 1000 inside containers)
        mkdir -p "$FULLPATH/_apps"
        chown $USER_UID:$USER_GID "$FULLPATH/_apps"

    else
        echo " - Skipping $FULLPATH (not found)"
    fi
done

echo ">>> Done! Suggested bind mounts inside LXCs:"
echo "  pct set <CTID> -mp0 /tank/appdata/_apps,mp=/config,acl=1"
