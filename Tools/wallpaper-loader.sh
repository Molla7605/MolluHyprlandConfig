#!/bin/bash

CACHE_FILE="$HOME/.cache/user-current-wallpaper.json"

sleep 1

monitors_json=$(hyprctl monitors -j)

monitors=$(echo "$monitors_json" | jq -r '.[].name')

wallpaper=$(echo '')

if [[ -f "$CACHE_FILE" || -s "$CACHE_FILE" ]]; then
    updated_monitors=$(cat "$CACHE_FILE")
    for i in $(echo "$updated_monitors" | jq -r '.[] | @base64'); do
        monitor=$(echo "$i" | base64 --decode | jq -r '.monitor')
        wallpaper=$(echo "$i" | base64 --decode | jq -r '.wallpaper')
        
        if [[ -f "$wallpaper" && -n "$(echo "$monitors" | grep "$monitor")" ]]; then
            hyprctl hyprpaper preload "$wallpaper" || echo notify-send 'hyprctl'
            if [ $? -ne 0 ]; then
                notify-send -u critical 'wallpaper-loader.sh' "Fail to set wallpaper \"$wallpaper\" at $monitor. (hyprpaper fail)"
            fi
            
            hyprctl hyprpaper wallpaper "$monitor,$wallpaper" || echo notify-send 'hyprctl'
            if [ $? -ne 0 ]; then
                notify-send -u critical 'wallpaper-loader.sh' "Fail to set wallpaper \"$wallpaper\" at $monitor. (hyprpaper fail)"
            fi
        else
            notify-send 'wallpaper-loader.sh' "Fail to set wallpaper \"$wallpaper\" at $monitor. (invalid file or monitor)"
        fi
    done
fi

(wal -n -q -i "$wallpaper" -b '#282a36' || echo notify-send 'pywal') &
wait

if [ $? -ne 0 ]; then
    notify-send 'wallpaper-loader.sh' "Fail to set color \"$wallpaper\". (pywal fail)"
    exit 1
fi

swaync-client -rs &
wait

exit 0
