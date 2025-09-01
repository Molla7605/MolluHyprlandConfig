BACKGROUND_DIR="$HOME/사진/wallpapers"
CACHE_FILE="$HOME/.cache/user-current-wallpaper.json"

wallpapers=$(find "$BACKGROUND_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \))

chosen_wallpaper=$(echo "$wallpapers" | wofi --dmenu --prompt "바탕화면 선택")

if [[ ! -f "$chosen_wallpaper" ]]; then
    notify-send 'wallpaper-change.sh' "No wallpaper selected."
    exit 1
fi

monitors_json=$(hyprctl monitors -j)

monitors=$(echo "$monitors_json" | jq -r '.[].name')

chosen_monitor=$(echo "$monitors" | wofi --dmenu --prompt "모니터 선택")

if [[ -z "$chosen_monitor" ]]; then
    notify-send -a 'wallpaper-change.sh' '바탕화면 관리자' "No monitor selected."
    exit 1
fi

(hyprctl hyprpaper reload "$chosen_monitor,$chosen_wallpaper" || echo notify-send -a 'hyprctl') &
wait

if [ $? -ne 0 ]; then
    notify-send -a 'wallpaper-change.sh' '바탕화면 관리자' "Fail to set wallpaper \"$chosen_wallpaper\" at $chosen_monitor. (hyprpaper fail)"
    exit 1
fi

(wal -n -q -i "$chosen_wallpaper" -b '#282a36' || echo notify-send -a 'pywal') &
wait

if [ $? -ne 0 ]; then
    notify-send -a 'wallpaper-change.sh' '바탕화면 관리자' "Fail to set color \"$chosen_wallpaper\" at $chosen_monitor. (pywal fail)"
    exit 1
fi

swaync-client -rs &
wait
    
monitors_info=$(cat "$CACHE_FILE" 2>/dev/null)
if [[ -z "$monitors_info" ]]; then
    monitors_info="[]"
fi

updated_monitors=$(echo "$monitors_info" | jq \
    --arg monitor_name "$chosen_monitor" \
    --arg wallpaper "$chosen_wallpaper" \
    'if any(.monitor == $monitor_name) then
        map(if .monitor == $monitor_name then .wallpaper = $wallpaper else . end)
    else
        . + [{monitor: $monitor_name, wallpaper: $wallpaper}]
    end')

echo "$updated_monitors" > "$CACHE_FILE"

notify-send -u low -a 'wallpaper-change.sh' '바탕화면 관리자' "Wallpaper \"$chosen_wallpaper\" applied to $chosen_monitor"

exit 0



