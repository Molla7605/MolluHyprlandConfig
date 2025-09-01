#!/bin/bash

IMAGE_OUTPUT_DIR="$HOME/사진"
VIDEO_OUTPUT_DIR="$HOME/비디오"
OPTION_JSON='
[
    { 
        "name": "전체 화면 캡쳐", 
        "command": "grim - | wl-copy" 
    },
    { 
        "name": "전체 화면 캡쳐 및 저장", 
        "command": "grim '"$IMAGE_OUTPUT_DIR"'/screenshot-$(date +%Y%m%d-%H%M%S).png" 
    },
    {
        "name": "화면 부분 캡쳐",
        "command": "slurp | grim -g - - | wl-copy" 
    },
    {
        "name": "화면 부분 캡쳐 및 저장",
        "command": "slurp | grim -g - '"$IMAGE_OUTPUT_DIR"'/screenshot-$(date +%Y%m%d-%H%M%S).png" 
    },
    {
        "name": "전체 화면 녹화 및 저장",
        "command": "wf-recorder --codec h264_vaapi --framerate 30 --file '"$VIDEO_OUTPUT_DIR"'/screen-record-$(date +%Y%m%d-%H%M%S).mp4 --audio" 
    },
    {
        "name": "화면 부분 녹화 및 저장(BingSin)",
        "command": ""
    }
]'

target_command_name=$(echo "$OPTION_JSON" | jq -r '.[].name' | wofi --dmenu --prompt "동작 선택")

if [[ -z "$target_command_name" ]]; then
    notify-send -u low -a 'screenshot.h' '스크린샷 관리자' '동작 취소됨'
    exit 1
fi

target_command=$(echo "$OPTION_JSON" | jq -r --arg command_key "$target_command_name" '.[] | select(.name == $command_key) | .command')

sleep 0.5
bash -c "$target_command" &

filename=""
case "$target_command_name" in
    "전체 화면 캡쳐 및 저장"|"화면 부분 캡쳐 및 저장")
        filename="$IMAGE_OUTPUT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        wait
        wl-copy -t image/png < "$filename"
        ;;
    "전체 화면 캡쳐"|"화면 부분 캡쳐")
        wait
        ;;
    "전체 화면 녹화 및 저장"|"화면 부분 녹화 및 저장")
        filename="$VIDEO_OUTPUT_DIR/screen-record-$(date +%Y%m%d-%H%M%S).mp4"
        notify-send -w -a 'screenshot.h' '스크린샷 관리자' '화면 녹화를 중지하려면 알림을 지우세요'
        killall wf-recorder
        ;;
esac

if [ $? -ne 0 ]; then
    notify-send '스크린샷 관리자' '동작 실행 실패'
    exit 1
fi

if [[ -n "$filename" ]]; then
    action=$(echo '')
    result=$(echo '')
    
    if [[ "$filename" == *.png ]]; then
        result=$(notify-send -u low -a 'screenshot.h' '스크린샷 관리자' "저장됨: $(basename "$filename")" -i "$filename" --action="opt1=사진 폴더 열기")
    else
        result=$(notify-send -u low -a 'screenshot.h' '스크린샷 관리자' "저장됨: $(basename "$filename")" -i "$filename" --action="opt1=비디오 폴더 열기")
    fi
    [[ -n "$result" ]] && xdg-open $(dirname "$filename")
else
    notify-send -u low -a 'screenshot.h' '스크린샷 관리자' "동작 \"$target_command_name\" 실행 완료"
fi

exit 0

