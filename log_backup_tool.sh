#!/bin/bash
# log_backup_tool.sh
# A simple log backup and archiving script
#
# Copyright (c) 2025 Murg Mihai Eduard
# Licensed under the MIT License
# See LICENSE file in the project root for more information.



backup () { #this is the actual backup utility
        
	date=$(date +"%d.%m.%Y-%H_%M") # backup date
	path=~/log_backup_$date        # backup path
    final_path=~/Backups/log_backup_$date
	mkdir $path                    # backup directory
	cd /var/log && sudo cp -r * $path # copying logs from /var/log
	sudo tar -czf $path.tar.gz $path &> /dev/null # compression and archieving
	sudo rm -rf $path # removing original directory
	clear
	echo "[INFO] Backup completed succesfully !" # user message
	echo "[INFO] Archive created at: $final_path
	"
	notify-send "A backup of your logs was completed successfully on $date."
	
	#creating a Backups directory, and check if it still is on the system
	
	if (ls ~ | grep -q "Backups" ); then
	    mv $path.tar.gz ~/Backups
        else
		mkdir ~/Backups
		echo "[INFO] Backup directory created."
		mv $path.tar.gz ~/Backups
        fi

}

cron_setup () { #this function reads the input from the user and edits the crontab file (crontab -e)

#reading the user input
	clear
	echo "Enter the backup schedule: ."
	echo "You can use '*' to mean 'any value'(e.g. every minute, every hour.)" 
	echo ""
	echo "(press enter to continue...) "
	read key
	
	echo "Enter the minute (0-59): "
	read minute

	echo "Enter the hour (0-23): "
	read hour

	echo "Enter the day of the month (1-31): "
	read day_month

	echo "Enter the month (1-12): "
	read month

	echo "Enter the day of the week (0-6, Sunday=0 or 7): "
	read day_week

#setting the crontab file

	(crontab -l 2>/dev/null; echo "$minute $hour $day_month $month $day_week /home/$USER/Log_Backup/log_backup_tool.sh") | crontab - &> /dev/null

#Verify if the options are correct

	if [ $? -ne 0 ]; then
	
		echo "Invalid options, try again !
		"
	else

       
		echo "[INFO] Your logs will be backed up according to the schedule: "
		echo "[INFO] hour:$hour minute:$minute day(month):$day_month month:$month day(week):$day_week .
      
		"
	fi
}




delete () { #function for deleting backups from ~/Backups

	
	echo "Are you absolutely sure you want to delete all the old backups ? Y/n"
		read answer
		
		if [[ "$answer" == "Y" ]] || [[ "$answer" == "y" ]]; then
			
			`sudo rm -r ~/Backups/log_backup_*`
			echo "[INFO] All log backups have been deleted."
		
		else
			echo "[INFO] No files were deleted."
		fi

	}

case $1 in
	setup)
		cron_setup
		;;
	backup)
		backup
		;;
	delete)
		if ( ls ~ | grep -q Backups ) && (ls ~/Backups | grep -q log_backup_); then
			delete
		
		else
			echo "[ERROR] There were no files inside the Backups directory and/or the directory was not found."
			echo "[INFO] Run a backup first."

		fi
		;;
	*)
		echo "[ERROR] Option not found !"
		
		;;
esac
