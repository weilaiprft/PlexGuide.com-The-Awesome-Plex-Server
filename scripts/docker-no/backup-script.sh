#!/bin/bash
YMLPROGRAM=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)
YMLDISPLAY=$(awk '/ymlprogram/{print $2}' /opt/plexguide/tmp.txt)

echo -n "Do you want to backup "$YMLPROGRAM" to your Google Drive (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    clear
    rm -r /home/plexguide/gdrive/Backup/"$YMLPROGRAM" 1>/dev/null 2>&1
    echo "1. Stopping Your Docker Program"
    echo "2. Compressing & Zipping Your Backup Request for "$YMLDISPLAY""
    echo ""
    mkdir -p /home/plexguide/gdrive/Backup/"$YMLPROGRAM"
    docker stop "$YMLPROGRAM" 1>/dev/null 2>&1
    zip -r /tmp/"$YMLPROGRAM".zip /opt/appdata/"$YMLPROGRAM"
    echo "3. Copy Files to Your Google Drive"
    rclone copy /tmp/"$YMLPROGRAM".zip gdrive:/Backup/"$YMLPROGRAM" -v --checksum --drive-chunk-size=64M 1>/dev/null 2>&1
    rm /tmp/"$YMLPROGRAM".zip
    docker start "$YMLPROGRAM" 1>/dev/null 2>&1
    echo ""
    echo "4. Restarting Your Docker Program"
    echo ""
    echo "Finished - Check Your Google Drive for the Backup Incase!"
else
    echo No
    clear
    echo Not Backed Up! - $YMLDISPALY
    echo
fi

read -n 1 -s -r -p "Press any key to continue "
