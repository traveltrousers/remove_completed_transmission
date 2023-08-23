#!/bin/sh
# script to check for complete torrents in transmission folder, then stop and move them
# either hard-code the MOVEDIR variable here…
#MOVEDIR=/home/mjdescy/media # the folder to move completed downloads to
# …or set MOVEDIR using the first command-line argument
# MOVEDIR=%1
# use transmission-remote to get torrent list from transmission-remote list
# use sed to delete first / last line of output, and remove leading spaces
# use cut to get first field from each line
TORRENTLIST=`transmission-remote -l | sed -e '1d;$d;s/^ *//' | cut -s -d ' ' -f 1`
# for each torrent in the list
for TORRENTID in $TORRENTLIST
do
echo "* * * * * Operations on torrent ID $TORRENTID starting. * * * * *"
# check if torrent download is completed
DL_COMPLETED=`transmission-remote -t $TORRENTID -i | grep -w 'Percent Done: 100%'`
# check torrent’s current state is “Stopped”, “Finished”, or “Idle”
STATE_STOPPED=`transmission-remote -t $TORRENTID -i | grep -w 'State: Stopped\|Finished\|Idle'`
# if the torrent is “Stopped”, “Finished”, or “Idle” after downloading 100%…
if [ "$DL_COMPLETED" != "" ] && [ "$STATE_STOPPED" != "" ]; then
# move the files and remove the torrent from Transmission
echo “Torrent $TORRENTID is completed.”
#echo “Moving downloaded file(s) to $MOVEDIR.”
#transmission-remote –torrent $TORRENTID –move $MOVEDIR
echo “Removing torrent $TORRENTID from list.”
transmission-remote -t $TORRENTID -r
else
echo “Torrent $TORRENTID is not completed. Ignoring.”
fi
echo "* * * * * Operations on torrent ID $TORRENTID completed. * * * *"
done