echo "종속성 패키지의 설정 파일을 적용합니다..."

xdg-mime default thunar.desktop inode/directory

xdg-mime default zen.desktop x-scheme-handler/http
xdg-mime default zen.desktop x-scheme-handler/https

hyprctl hyprpaper wallpaper ",./plana_dark.png"
wal -n -q -i "./plana_dark.png" -b '#282a36' || echo notify-send -a 'pywal'

echo "종속성 패키지의 설정 파일을 복사하는 중..."

sudo cp -f ./DotConfig/hypr ~/.config/hypr
sudo cp -f ./DotConfig/kitty ~/.config/kitty
sudo cp -f ./DotConfig/swaync ~/.config/swaync
sudo cp -f ./DotConfig/waybar ~/.config/waybar
sudo cp -f ./DotConfig/wofi ~/.config/wofi

echo "커스텀 스크립트 파일을 복사하는 중..."

sudo mkdir -p ~/.local/bin

sudo cp ./Tools/screenshot.sh ~/.local/bin
sudo cp ./Tools/wallpaper-change.sh ~/.local/bin
sudo cp ./Tools/wallpaper-loader.sh ~/.local/bin

echo "커스텀 스크립트 파일에 권한을 부여하는 중..."

sudo chmod +x ~/.local/bin/screenshot.sh
sudo chmod +x ~/.local/bin/wallpaper-change.sh
sudo chmod +x ~/.local/bin/wallpaper-loader.sh
