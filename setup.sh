#!/bin/bash
# setup.sh
#
# Copyright (c) 2025 Murg Mihai Eduard
# Licensed under the MIT License
# See LICENSE file in the project root for more information.


#read user input

clear
echo "Enter the backup schedule: ."
echo "You can use '*' to mean 'any value'(e.g. every minute, every hour." 
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


#set crontab file with user input

(crontab -l 2>/dev/null; echo "$minute $hour $day_month $month $day_week /home/$USER/Log_Backup/log_backup_saver.sh") | crontab - &> /dev/null

#Verify if options are correct

if [ $? -ne 0 ]; then
	
	echo "
Invalid options, try again !
"
else

        echo "
[INFO] Your logs will be backed up according to the schedule:
       hour:$hour minute:$minute day(month):$day_month month:$month day(week):$day_week.
       "
fi
