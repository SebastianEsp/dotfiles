#!/usr/bin/env sh

sleep 20
hyprctl dispatch exec -- '[workspace 2 silent]' firefox -P default &
sleep 20
hyprctl dispatch exec -- '[workspace 10 silent]' firefox -P left &
sleep 20
hyprctl dispatch exec -- '[workspace 9 silent]' firefox -P right &