echo "필요 종속성 패키지를 설치합니다..."

sudo pacman -Syu
sudo pacman -S --needed swaync waybar wofi kitty thunar grim slurp wl-clipboard wf-recorder wireplumber easyeffects swayosd

yay
yay -S --needed python-pywal16

if [ $? -ne 0 ]; then
    echo "종속성 설치 실패"
    exit 1
fi

echo "종속성 패키지의 설정 파일을 적용합니다..."

xdg-mime default thunar.desktop inode/directory

xdg-mime default zen.desktop x-scheme-handler/http
xdg-mime default zen.desktop x-scheme-handler/https

echo "종속성 패키지의 설정 파일을 복사하는 중..."

sudo cp -r ./DotConfig/hypr ~/.config/hypr
sudo cp -r ./DotConfig/kitty ~/.config/kitty
sudo cp -r ./DotConfig/swaync ~/.config/swaync
sudo cp -r ./DotConfig/waybar ~/.config/waybar
sudo cp -r ./DotConfig/wofi ~/.config/wofi

echo "커스텀 스크립트 파일을 복사하는 중..."

sudo mkdir -p ~/.local/bin

sudo cp ./Tools/screenshot.sh ~/.local/bin
sudo cp ./Tools/wallpaper-change.sh ~/.local/bin
sudo cp ./Tools/wallpaper-loader.sh ~/.local/bin

echo "커스텀 스크립트 파일에 권한을 부여하는 중..."

sudo chmod +x ~/.local/bin/screenshot.sh
sudo chmod +x ~/.local/bin/wallpaper-change.sh
sudo chmod +x ~/.local/bin/wallpaper-loader.sh
