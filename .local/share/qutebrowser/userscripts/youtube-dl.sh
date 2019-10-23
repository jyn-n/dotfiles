#!/bin/sh

green='\e[0;32m'
red='\e[0;31m'
blue='\e[0;34m'
reset='\e[0m'

tmpdir=$(mktemp -d)

out="/dev/null"
[[ -z $1 ]] || out=$1

touch $out

echo -e "$(date --rfc-3339=seconds) $QUTE_URL ${blue}started${reset}" >> $out
echo "message-info \"Downloading $QUTE_URL via youtube-dl... \"" >> "$QUTE_FIFO"

youtube-dl -i -f bestaudio -x -o "$tmpdir/%(title)s.%(ext)s" "$QUTE_URL" 2>&1 >> $out

if [ $? == 0 ]; then
	echo -e "$(date --rfc-3339=seconds) $QUTE_URL ${green}downloaded${reset}" >> $out
	echo "message-info \"Downloading $QUTE_URL via youtube-dl... done.\"" >> "$QUTE_FIFO"
else
	echo -e "$(date --rfc-3339=seconds) $QUTE_URL ${red}failed${reset}" >> $out
	echo "message-error \"Downloading $QUTE_URL via youtube-dl... failed\"" >> "$QUTE_FIFO"
fi

ls $tmpdir | grep -v "opus$" | while read f; do
	echo -e "${blue}Coverting${reset} $f to opus" >> $out
	ffmpeg -nostdin -i "$tmpdir/$f" "$tmpdir/$(echo $f | sed 's/\.[^.]*$/.opus/')" 2>&1 && rm "$tmpdir/$f" || echo -e "$f ${red}conversion failed${reset}"
done

echo -e "$(date --rfc-3339=seconds) $QUTE_URL ${green}converted${reset}" >> $out
echo "message-info \"Converting $QUTE_URL via ffmpeg... done.\"" >> "$QUTE_FIFO"

mv $tmpdir/*.opus ~/ytdl

rm -r $tmpdir

