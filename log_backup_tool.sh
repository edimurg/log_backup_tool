#!/bin/bash
# log_backup_saver.sh
# A simple log backup and archiving script
#
# Copyright (c) 2025 Murg Mihai Eduard
# Licensed under the MIT License
# See LICENSE file in the project root for more information.


date=$(date +"%d.%m.%Y-%H_%M") # backup date
path=~/log_backup_$date        # backup path
mkdir $path                    # backup directory
cd /var/log && sudo cp -r * $path # copying logs from /var/log
sudo tar -czf $path.tar.gz $path &> /dev/null # compression and archieving
sudo rm -rf $path # removing original directory
clear
echo "[INFO] Backup completed succesfully !" # user message
echo "[INFO] Archive created at: $path
"
notify-send "A backup of your logs was completed successfully on $date."
