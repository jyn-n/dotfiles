[ "running" = $(systemctl show mpd.service --user | grep SubState | sed 's/^SubState=//') ] || systemctl start mpd --user
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx || setterm --blength 0
