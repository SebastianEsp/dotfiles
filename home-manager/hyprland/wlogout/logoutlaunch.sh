#!/usr/bin/env sh
# Based on https://github.com/prasanthrangan/hyprdots

#// Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null
then
    pkill -x "wlogout"
    exit 0
fi

#// detect monitor res
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

#// scale config layout and style
export mgn=$(( y_mon * 28 / hypr_scale ))
export hvr=$(( y_mon * 23 / hypr_scale ))

#// scale font size
export fntSize=$(( y_mon * 2 / 100 ))

#// eval hypr border radius
export active_rad=$(( hypr_border * 5 ))
export button_rad=$(( hypr_border * 8 ))

#// eval config files
wlTmplt="$HOME/.config/wlogout/style.css"
wlStyle="$(envsubst < $wlTmplt)"

#// launch wlogout
wlogout -b 6 -c 0 -r 0 -m 0 --css <(echo "${wlStyle}") --protocol layer-shell