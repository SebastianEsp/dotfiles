#!/usr/bin/env bash
# Credit https://gitlab.com/xPMo/dotfiles.cli/-/blob/dots/.local/lib/waybar/playerctl.sh
exec 2>"$XDG_RUNTIME_DIR/waybar-playerctl.log"
IFS=$'\n\t'

while getopts ":p:" opt; do
  case ${opt} in
    p ) player=$OPTARG;;
    \? ) echo "Usage: cmd [-p]";;
  esac
done

count=0

while true; do
	while read -r playing position length name artist title arturl hpos hlen; do
		# remove leaders
		playing=${playing:1} position=${position:1} length=${length:1} name=${name:1}
		artist=${artist:1} title=${title:1} arturl=${arturl:1} hpos=${hpos:1} hlen=${hlen:1}

		# build line
		#line="${artist:+$artist ${title:+- }}${title:+$title }${hpos:+$hpos${hlen:+|}}$hlen"

        preview="${artist:+$artist ${title:+- }}${title:+$title }"

        # Scrolling artist info
        if [[ "${#preview}" -gt 23 ]]; then
            line="${preview:$count:23}... ${hpos:+$hpos${hlen:+|}}$hlen"
            #line="$count - ${#preview}"
            if [[ $count -lt "${#preview}" ]]; then
                count=$((count + 1))
            fi

            if [[ $count -eq $(("${#preview}" - 23)) ]]; then
                count=0
            fi
        else
            line="${artist:+$artist ${title:+- }}${title:+$title }${hpos:+$hpos${hlen:+|}}$hlen"
        fi

		# json escaping
		line="${line//\"/\\\"}"
		((percentage = length ? (100 * (position % length)) / length : 0))
		case $playing in
		⏸️ | Paused) text=" $line" ;;
		▶️ | Playing) text=" $line" ;;
		*) text='<span foreground=\"#073642\">⏹</span>' ;;
		esac

		# exit if print fails
		printf '{"text":"%s","class":"%s","percentage":%s}\n' \
			"$text" "$percentage" "$percentage" || break 2

	done < <(
		# requires playerctl>=2.0
		# Add non-space character ":" before each parameter to prevent 'read' from skipping over them
		playerctl --follow metadata --player $player --format \
			$':{{emoji(status)}}\t:{{position}}\t:{{mpris:length}}\t:{{playerName}}\t:{{markup_escape(artist)}}\t:{{markup_escape(title)}}\t:{{mpris:artUrl}}\t:{{duration(position)}}\t:{{duration(mpris:length)}}' &
		echo $! >"$XDG_RUNTIME_DIR/waybar-playerctl.pid"
	)

	# no current players
	# exit if print fails
	echo '' || break
	sleep 15

done

kill "$(<"$XDG_RUNTIME_DIR/waybar-playerctl.pid")"
