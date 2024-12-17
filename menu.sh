#!/usr/bin/env bash

##
## Variáveis gerais
##

TMP=${TMP:-/tmp}
HOME=${HOME:-/home/carlos}

#-------------------------------------------------------------------------------------
# Autentica o SUDO
#

if [ "$(id -u)" -ne 0 ]; then
	sudo echo -n
fi

##------------------------------------------------------------------------------------
## Configuração inicial de diretórios
##

function configUserDirectories() {
	if [ ! -d "$HOME"/google-drive ]; then
		return 1
	fi

	[[ ! -d "$HOME"/_junkdrawer ]] && mkdir -p "$HOME"/_junkdrawer

	# Diretórios do Google Driver
	[[ ! -d "$HOME"/Documentos/docs ]] && ln -s "$HOME"/google-drive/docs "$HOME"/Documentos/docs
	[[ ! -d "$HOME"/Documentos/docs-archive ]] && ln -s "$HOME"/google-drive/docs-archive "$HOME"/Documentos/docs-archive
	[[ ! -d "$HOME"/Documentos/LTS ]] && ln -s "$HOME"/google-drive/LTS "$HOME"/Documentos/LTS
	[[ ! -d "$HOME"/Documentos/projects ]] && ln -s "$HOME"/google-drive/projects "$HOME"/Documentos/projects
	[[ ! -d "$HOME"/keyring ]] && ln -s "$HOME"/google-drive/keyring "$HOME"/keyring
	[[ ! -d "$HOME"/scripts ]] && ln -s "$HOME"/google-drive/scripts "$HOME"/scripts
}

##------------------------------------------------------------------------------------
## Instalar pré-requisitos
##

function installPrerequisites() {
	if ! grep -q '.*contrib$' /etc/apt/sources.list; then
		# Usa o "retrovisor" do sed (\1 = primeiro grupo) para fazer referência a tudo capturado pelo grupo
		sed -r -i 's/^deb(.*)$/deb\1 non-free non-free-firmware contrib/g' /etc/apt/sources.list
	fi

	sudo apt-get update -y
	sudo apt-get upgrade -y

	! dpkg -s whiptail >/dev/null 2>&1 && sudo apt-get install whiptail -y
	! dpkg -s wget >/dev/null 2>&1 && sudo apt-get install wget -y
	! dpkg -s curl >/dev/null 2>&1 && sudo apt-get install curl -y
	! dpkg -s rclone >/dev/null 2>&1 && sudo apt-get install rclone -y
	! dpkg -s gawk >/dev/null 2>&1 && sudo apt-get install gawk -y
	! dpkg -s python3-all >/dev/null 2>&1 && sudo apt-get install python3-all -y
	! dpkg -s temurin-8-jdk >/dev/null 2>&1 && sudo apt-get install temurin-8-jdk -y
	! dpkg -s temurin-17-jdk >/dev/null 2>&1 && sudo apt-get install temurin-17-jdk -y
	! dpkg -s temurin-23-jdk >/dev/null 2>&1 && sudo apt-get install temurin-23-jdk -y
	! dpkg -s unzip >/dev/null 2>&1 && sudo apt-get install unzip -y
	! dpkg -s libreoffice >/dev/null 2>&1 && sudo apt-get install libreoffice --no-install-recommends -y
	! dpkg -s cabextract >/dev/null 2>&1 && sudo apt-get install cabextract -y
	! dpkg -s libmspack0 >/dev/null 2>&1 && sudo apt-get install libmspack0 -y
	! dpkg -s ttf-mscorefonts-installer >/dev/null 2>&1 && sudo apt-get install ttf-mscorefonts-installer -y
}

##------------------------------------------------------------------------------------
## Instalar bibliotecas
##

function installLibraries() {
	! dpkg -s libx11-dev >/dev/null 2>&1 && sudo apt-get install libx11-dev -y
	! dpkg -s libx11-xcb-dev >/dev/null 2>&1 && sudo apt-get install libx11-xcb-dev -y
	! dpkg -s libxext6 >/dev/null 2>&1 && sudo apt-get install libxext6 -y
	! dpkg -s libxmu-dev >/dev/null 2>&1 && sudo apt-get install libxmu -y
	! dpkg -s libxmuu-dev >/dev/null 2>&1 && sudo apt-get install libxmuu -y
	! dpkg -s libxext-dev >/dev/null 2>&1 && sudo apt-get install libxext-dev -y
	! dpkg -s libxcb1-dev >/dev/null 2>&1 && sudo apt-get install libxcb1-dev -y
	! dpkg -s libxcb-damage0-dev >/dev/null 2>&1 && sudo apt-get install libxcb-damage0-dev -y
	! dpkg -s libx11-dev >/dev/null 2>&1 && sudo apt-get install libx11-dev -y
	! dpkg -s libx11-xcb-dev >/dev/null 2>&1 && sudo apt-get install libx11-xcb-dev -y
	! dpkg -s libxext6 >/dev/null 2>&1 && sudo apt-get install libxext6 -y
	! dpkg -s libxcb-dpms0-dev >/dev/null 2>&1 && sudo apt-get install libxcb-dpms0-dev -y
	! dpkg -s libxcb-xfixes0-dev >/dev/null 2>&1 && sudo apt-get install libxcb-xfixes0-dev -y
	! dpkg -s libxcb-shape0-dev >/dev/null 2>&1 && sudo apt-get install libxcb-shape0-dev -y
	! dpkg -s libxcb-render-util0-dev >/dev/null 2>&1 && sudo apt-get install libxcb-render-util0-dev -y
	! dpkg -s libxcb-render0-dev >/dev/null 2>&1 && sudo apt-get install libxcb-render0-dev -y
	! dpkg -s libxcb-randr0-dev >/dev/null 2>&1 && sudo apt-get install libxcb-randr0-dev -y
	! dpkg -s libxcb-composite0-dev >/dev/null 2>&1 && sudo apt-get install libxcb-composite0-dev -y
	! dpkg -s libxcb-image0-dev >/dev/null 2>&1 && sudo apt-get install libxcb-image0-dev -y
	! dpkg -s libxcb-present-dev >/dev/null 2>&1 && sudo apt-get install libxcb-present-dev -y
	! dpkg -s libxcb-glx0-dev >/dev/null 2>&1 && sudo apt-get install libxcb-glx0-dev -y
	! dpkg -s libpixman-1-dev >/dev/null 2>&1 && sudo apt-get install libpixman-1-dev -y
	! dpkg -s libdbus-1-dev >/dev/null 2>&1 && sudo apt-get install libdbus-1-dev -y
	! dpkg -s libconfig-dev >/dev/null 2>&1 && sudo apt-get install libconfig-dev -y
	! dpkg -s libgl-dev >/dev/null 2>&1 && sudo apt-get install libgl-dev -y
	! dpkg -s libegl-dev >/dev/null 2>&1 && sudo apt-get install libegl-dev -y
	! dpkg -s libpcre2-dev >/dev/null 2>&1 && sudo apt-get install libpcre2-dev -y
	! dpkg -s libevdev-dev >/dev/null 2>&1 && sudo apt-get install libevdev-dev -y
	! dpkg -s uthash-dev >/dev/null 2>&1 && sudo apt-get install uthash-dev -y
	! dpkg -s libev-dev >/dev/null 2>&1 && sudo apt-get install libev-dev -y
	! dpkg -s libx11-xcb-dev >/dev/null 2>&1 && sudo apt-get install libx11-xcb-dev -y
	! dpkg -s libicu-dev >/dev/null 2>&1 && sudo apt-get install libicu-dev -y
	! dpkg -s libncurses-dev >/dev/null 2>&1 && sudo apt-get install libncurses-dev -y
	! dpkg -s libgmp-dev >/dev/null 2>&1 && sudo apt-get install libgmp-dev -y
	! dpkg -s zlib1g-dev >/dev/null 2>&1 && sudo apt-get install zlib1g-dev -y
	! dpkg -s libperl-dev >/dev/null 2>&1 && sudo apt-get install libperl-dev -y
	! dpkg -s libedit-dev >/dev/null 2>&1 && sudo apt-get install libedit-dev -y
	! dpkg -s libpam0g-dev >/dev/null 2>&1 && sudo apt-get install libpam0g-dev -y
	! dpkg -s libpam-dev >/dev/null 2>&1 && sudo apt-get install libpam-dev -y
	! dpkg -s libkrb5-dev >/dev/null 2>&1 && sudo apt-get install libkrb5-dev -y
	! dpkg -s libldap2-dev >/dev/null 2>&1 && sudo apt-get install libldap2-dev -y
	! dpkg -s libxslt1-dev >/dev/null 2>&1 && sudo apt-get install libxslt1-dev -y
	! dpkg -s libossp-uuid-dev >/dev/null 2>&1 && sudo apt-get install libossp-uuid-dev -y
	! dpkg -s bison >/dev/null 2>&1 && sudo apt-get install bison -y
	! dpkg -s flex >/dev/null 2>&1 && sudo apt-get install flex -y
	! dpkg -s opensp >/dev/null 2>&1 && sudo apt-get install opensp -y
	! dpkg -s tcl-dev >/dev/null 2>&1 && sudo apt-get install tcl-dev -y
	! dpkg -s xsltproc >/dev/null 2>&1 && sudo apt-get install xsltproc -y
	! dpkg -s libperl-dev >/dev/null 2>&1 && sudo apt-get install libperl-dev -y
	! dpkg -s libedit-dev >/dev/null 2>&1 && sudo apt-get install libedit-dev -y
	! dpkg -s libossp-uuid-dev >/dev/null 2>&1 && sudo apt-get install libossp-uuid-dev -y
	! dpkg -s dpkg-dev >/dev/null 2>&1 && sudo apt-get install dpkg-dev -y
	! dpkg -s docbook-dsssl >/dev/null 2>&1 && sudo apt-get install docbook-dsssl -y
	! dpkg -s docbook >/dev/null 2>&1 && sudo apt-get install docbook -y
	! dpkg -s libreadline-dev >/dev/null 2>&1 && sudo apt-get install libreadline-dev -y
	! dpkg -s libasound2-dev >/dev/null 2>&1 && sudo apt-get install libasound2-dev -y
	! dpkg -s libasound2 >/dev/null 2>&1 && sudo apt-get install libasound2 -y
	! dpkg -s libalsaplayer-dev >/dev/null 2>&1 && sudo apt-get install libalsaplayer-dev -y
	! dpkg -s sdl2 >/dev/null 2>&1 && sudo apt-get install sdl2 -y
	! dpkg -s sdl2_image >/dev/null 2>&1 && sudo apt-get install sdl2_image -y
	! dpkg -s libsdl2-image-dev >/dev/null 2>&1 && sudo apt-get install libsdl2-image-dev -y
	! dpkg -s gcc-multilib >/dev/null 2>&1 && sudo apt-get install gcc-multilib -y
	! dpkg -s bsdtar >/dev/null 2>&1 && sudo apt-get install bsdtar -y
	! dpkg -s libarchive-tools >/dev/null 2>&1 && sudo apt-get install libarchive-tools -y
	! dpkg -s patchelf >/dev/null 2>&1 && sudo apt-get install patchelf -y
	! dpkg -s rpm2cpio >/dev/null 2>&1 && sudo apt-get install rpm2cpio -y
	! dpkg -s lib32ncurses-dev >/dev/null 2>&1 && sudo apt-get install lib32ncurses-dev -y
	! dpkg -s libasound2-dev >/dev/null 2>&1 && sudo apt-get install libasound2-dev -y
	! dpkg -s libx11-dev >/dev/null 2>&1 && sudo apt-get install libx11-dev -y
	! dpkg -s libxrandr-dev >/dev/null 2>&1 && sudo apt-get install libxrandr-dev -y
	! dpkg -s libxi-dev >/dev/null 2>&1 && sudo apt-get install libxi-dev -y
	! dpkg -s libgl1-mesa-dev >/dev/null 2>&1 && sudo apt-get install libgl1-mesa-dev -y
	! dpkg -s libglu1-mesa-dev >/dev/null 2>&1 && sudo apt-get install libglu1-mesa-dev -y
	! dpkg -s libxcursor-dev >/dev/null 2>&1 && sudo apt-get install libxcursor-dev -y
	! dpkg -s libxinerama-dev >/dev/null 2>&1 && sudo apt-get install libxinerama-dev -y
}

##------------------------------------------------------------------------------------
## Instalar Fontes
##

function installPlFonts() {
	! dpkg -s fonts-powerline >/dev/null 2>&1 && sudo apt-get install fonts-powerline -y

	if [ "$?" -eq 0 ]; then
		echo "Powerline fonts has been installed!"
	fi

	while true; do
		read -p "Install another font? (Y/N): " confirm
		if [[ $confirm == [nN] ]]; then
			break
		fi
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"
	done
}

##--------------------------------------------------------------------------------------
## Instalar ferramentas de desenvolvimento
##

function installDevTools() {
	! dpkg -s build-essential >/dev/null 2>&1 && sudo apt-get install build-essential -y
	! dpkg -s fakeroot >/dev/null 2>&1 && sudo apt-get install fakeroot -y
	! dpkg -s devscripts >/dev/null 2>&1 && sudo apt-get install devscripts -y
	! dpkg -s make >/dev/null 2>&1 && sudo apt-get install make -y
	! dpkg -s cmake >/dev/null 2>&1 && sudo apt-get install cmake -y
	! dpkg -s ninja-build >/dev/null 2>&1 && sudo apt-get install ninja-build -y
	! dpkg -s meson >/dev/null 2>&1 && sudo apt-get install meson -y
	! dpkg -s linux-headers-"$(uname -r)" >/dev/null 2>&1 && sudo apt-get install linux-headers-"$(uname -r)" -y
	! dpkg -s libglvnd-dev >/dev/null 2>&1 && sudo apt-get install libglvnd-dev -y
	! dpkg -s pkg-config >/dev/null 2>&1 && sudo apt-get install pkg-config -y
	! dpkg -s vim >/dev/null 2>&1 && sudo apt-get install vim -y
	! dpkg -s git >/dev/null 2>&1 && sudo apt-get install git -y
	! dpkg -s gh >/dev/null 2>&1 && sudo apt-get install gh -y
	! dpkg -s binwalk >/dev/null 2>&1 && sudo apt-get install binwalk -y
	! dpkg -s gettext >/dev/null 2>&1 && sudo apt-get install gettext -y
	! dpkg -s python3-all >/dev/null 2>&1 && sudo apt-get install python3-all -y
	! dpkg -s python3-pip >/dev/null 2>&1 && sudo apt-get install python3-pip -y
	! dpkg -s pipx >/dev/null 2>&1 && sudo apt install --no-install-recommends pipx -y

	if [ ! -f "$HOME"/.cargo/bin/cargo ]; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	fi

	if [ -d "$HOME"/.nvm ]; then
		PATH=$PATH:"$HOME"/.nvm
	fi

	if ! which nvm; then
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
		source "$HOME"/.bashrc
		nvm install 22
	fi

}

##--------------------------------------------------------------------------------------
## Instalar utilitários
##

function installUtilities() {
	! dpkg -s alacritty >/dev/null 2>&1 && sudo apt-get install alacritty -y
	! dpkg -s kitty >/dev/null 2>&1 && sudo apt-get install kitty -y
	! dpkg -s keepassxc >/dev/null 2>&1 && sudo apt-get install keepassxc -y
	! dpkg -s inotify-tools >/dev/null 2>&1 && sudo apt-get install inotify-tools -y
	! dpkg -s lolcat >/dev/null 2>&1 && sudo apt-get install lolcat -y
	! dpkg -s zenity >/dev/null 2>&1 && sudo apt-get install zenity -y
	! dpkg -s scrot >/dev/null 2>&1 && sudo apt-get install scrot -y
	! dpkg -s flameshot >/dev/null 2>&1 && sudo apt-get install flameshot -y
	! dpkg -s gromit >/dev/null 2>&1 && sudo apt-get install gromit -y
	! dpkg -s gromit-mpx >/dev/null 2>&1 && sudo apt-get install gromit-mpx -y
	! dpkg -s feh >/dev/null 2>&1 && sudo apt-get install feh -y
	! dpkg -s magnus >/dev/null 2>&1 && sudo apt-get install magnus -y
	! dpkg -s qalculate-gtk >/dev/null 2>&1 && sudo apt-get install qalculate-gtk -y
	! dpkg -s mpv >/dev/null 2>&1 && sudo apt-get install mpv -y
	! dpkg -s vlc >/dev/null 2>&1 && sudo apt-get install vlc -y
	! dpkg -s cmus >/dev/null 2>&1 && sudo apt-get install cmus -y
	! dpkg -s deadbeef >/dev/null 2>&1 && sudo apt-get install deadbeef -y
	! dpkg -s exa >/dev/null 2>&1 && sudo apt-get install exa -y
	! dpkg -s netcat >/dev/null 2>&1 && sudo apt-get install netcat -y
	! dpkg -s netcat-traditional >/dev/null 2>&1 && sudo apt-get install netcat-traditional -y
	! dpkg -s prettyping >/dev/null 2>&1 && sudo apt-get install prettyping -y
	! dpkg -s nala >/dev/null 2>&1 && sudo apt-get install nala -y
	! dpkg -s htop >/dev/null 2>&1 && sudo apt-get install htop -y
	! dpkg -s rofi >/dev/null 2>&1 && sudo apt-get install rofi -y
	! dpkg -s newsboat >/dev/null 2>&1 && sudo apt-get install newsboat -y
	! dpkg -s pulsemixer >/dev/null 2>&1 && sudo apt-get install pulsemixer -y
	! dpkg -s neofetch >/dev/null 2>&1 && sudo apt-get install neofetch -y
	! dpkg -s screenfetch >/dev/null 2>&1 && sudo apt-get install screenfetch -y
	! dpkg -s mp3info >/dev/null 2>&1 && sudo apt-get install mp3info -y
	! dpkg -s trash-cli >/dev/null 2>&1 && sudo apt-get install trash-cli -y
	! dpkg -s calcurse >/dev/null 2>&1 && sudo apt-get install calcurse -y
	! dpkg -s fzf >/dev/null 2>&1 && sudo apt-get install fzf -y
	! dpkg -s fd-find >/dev/null 2>&1 && sudo apt-get install fd-find -y
	! dpkg -s f3 >/dev/null 2>&1 && sudo apt-get install f3 -y
	! dpkg -s ripgrep >/dev/null 2>&1 && sudo apt-get install ripgrep -y
	! dpkg -s duf >/dev/null 2>&1 && sudo apt-get install duf -y
	! dpkg -s unclutter >/dev/null 2>&1 && sudo apt-get install unclutter -y
	! dpkg -s numlockx >/dev/null 2>&1 && sudo apt-get install numlockx -y
	! dpkg -s xss-lock >/dev/null 2>&1 && sudo apt-get install xss-lock -y
	! dpkg -s xclip >/dev/null 2>&1 && sudo apt-get install xclip -y
	! dpkg -s x11-apps >/dev/null 2>&1 && sudo apt-get install x11-apps -y
	! dpkg -s filezilla >/dev/null 2>&1 && sudo apt-get install filezilla -y
	! dpkg -s kcolorchooser >/dev/null 2>&1 && sudo apt-get install kcolorchooser -y
	! dpkg -s kronometer >/dev/null 2>&1 && sudo apt-get install kronometer -y
	! dpkg -s rar >/dev/null 2>&1 && sudo apt-get install rar -y
	! dpkg -s unrar >/dev/null 2>&1 && sudo apt-get install unrar -y
	! dpkg -s nmap >/dev/null 2>&1 && sudo apt-get install nmap -y
	! dpkg -s obs-studio >/dev/null 2>&1 && sudo apt-get install obs-studio -y
	! dpkg -s psensor >/dev/null 2>&1 && sudo apt-get install psensor -y
	! dpkg -s ffmpeg >/dev/null 2>&1 && sudo apt-get install ffmpeg -y
	! dpkg -s imagemagick >/dev/null 2>&1 && sudo apt-get install imagemagick -y
	! dpkg -s sox >/dev/null 2>&1 && sudo apt-get install sox -y
	! dpkg -s powerline >/dev/null 2>&1 && sudo apt-get install powerline -y

	if ! pip3 list 2>&1 | grep -q powerline-shell; then
		pip3 install powerline-shell --break-system-packages
	fi

	if ! pip3 list 2>&1 | grep -q yt-dlp; then
		pip3 install yt-dlp --break-system-packages
	fi

	if ! which glow; then
		sudo mkdir -p /etc/apt/keyrings
		curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
		echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
		sudo apt update && sudo apt install glow -y
	fi
}

##--------------------------------------------------------------------------------------
## Instalar utilitários
##

function installAccessories() {
	! dpkg -s gnome-screensaver >/dev/null 2>&1 && sudo apt-get install gnome-screensaver -y
	! dpkg -s gnome-bluetooth >/dev/null 2>&1 && sudo apt-get install gnome-bluetooth -y
	! dpkg -s cava >/dev/null 2>&1 && sudo apt-get install cava -y
	! dpkg -s screenkey >/dev/null 2>&1 && sudo apt-get install screenkey -y
	! dpkg -s dosbox >/dev/null 2>&1 && sudo apt-get install dosbox -y
}

##--------------------------------------------------------------------------------------
## Instalar software científico e especializado
##

function installTechSciSoftware() {
	! dpkg -s kikad >/dev/null 2>&1 && sudo apt-get install kicad -y
	! dpkg -s logisim >/dev/null 2>&1 && sudo apt-get install logisim -y
	! dpkg -s simulide >/dev/null 2>&1 && sudo apt-get install simulide -y
	! dpkg -s glogic >/dev/null 2>&1 && sudo apt-get install glogic -y
}

##--------------------------------------------------------------------------------------
## Instalar Fish Shell
##

function installFishShell() {
	if ! which fish; then
		echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
		curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg >/dev/null
		sudo apt update
		sudo apt install fish -y
	fi
}

##--------------------------------------------------------------------------------------
## Instalar QTile
##

function installQtile() {
	TMPFILE=$(mktemp -p "$TMP"/)
	DESKTOPFILE="/usr/share/xsessions/qtile.desktop"

	! dpkg -s lightdm >/dev/null 2>&1 && sudo apt-get install lightdm -y

	if ! sudo systemctl status lightdm | grep -q "lightdm.service; enabled"; then
		dpkg -s lightdm >/dev/null 2>&1 && sudo systemctl enable lightdm
	fi

	! dpkg -s cmake >/dev/null 2>&1 && sudo apt install cmake -y
	! dpkg -s libconfig-dev >/dev/null 2>&1 && sudo apt install libconfig-dev -y
	! dpkg -s libdbus-1-dev >/dev/null 2>&1 && sudo apt install libdbus-1-dev -y
	! dpkg -s libegl-dev >/dev/null 2>&1 && sudo apt install libegl-dev -y
	! dpkg -s libev-dev >/dev/null 2>&1 && sudo apt install libev-dev -y
	! dpkg -s libgl-dev >/dev/null 2>&1 && sudo apt install libgl-dev -y
	! dpkg -s libepoxy-dev >/dev/null 2>&1 && sudo apt install libepoxy-dev -y
	! dpkg -s libpcre2-dev >/dev/null 2>&1 && sudo apt install libpcre2-dev -y
	! dpkg -s libpixman-1-dev >/dev/null 2>&1 && sudo apt install libpixman-1-dev -y
	! dpkg -s libx11-xcb-dev >/dev/null 2>&1 && sudo apt install libx11-xcb-dev -y
	! dpkg -s libxcb1-dev >/dev/null 2>&1 && sudo apt install libxcb1-dev -y
	! dpkg -s libxcb-composite0-dev >/dev/null 2>&1 && sudo apt install libxcb-composite0-dev -y
	! dpkg -s libxcb-damage0-dev >/dev/null 2>&1 && sudo apt install libxcb-damage0-dev-y
	! dpkg -s libxcb-glx0-dev >/dev/null 2>&1 && sudo apt install libxcb-glx0-dev -y
	! dpkg -s libxcb-image0-dev >/dev/null 2>&1 && sudo apt install libxcb-image0-dev -y
	! dpkg -s libxcb-present-dev >/dev/null 2>&1 && sudo apt install libxcb-present-dev -y
	! dpkg -s libxcb-randr0-dev >/dev/null 2>&1 && sudo apt install libxcb-randr0-dev -y
	! dpkg -s libxcb-render0-dev >/dev/null 2>&1 && sudo apt install libxcb-render0-dev -y
	! dpkg -s libxcb-render-util0-dev >/dev/null 2>&1 && sudo apt install libxcb-render-util0-dev -y
	! dpkg -s libxcb-shape0-dev >/dev/null 2>&1 && sudo apt install libxcb-shape0-dev -y
	! dpkg -s libxcb-util-dev >/dev/null 2>&1 && sudo apt install libxcb-util-dev -y
	! dpkg -s libxcb-xfixes0-dev >/dev/null 2>&1 && sudo apt install libxcb-xfixes0-dev -y
	! dpkg -s meson >/dev/null 2>&1 && sudo apt install meson -y
	! dpkg -s ninja-build >/dev/null 2>&1 && sudo apt install ninja-build -y
	! dpkg -s uthash-dev >/dev/null 2>&1 && sudo apt install uthash-dev -y
	! dpkg -s xserver-xorg-core >/dev/null 2>&1 && sudo apt install xserver-xorg-core -y
	! dpkg -s xserver-xorg-input-libinput >/dev/null 2>&1 && sudo apt install xserver-xorg-input-libinput -y
	! dpkg -s xinit >/dev/null 2>&1 && sudo apt install xinit -y
	! dpkg -s libpangocairo-1.0-0 >/dev/null 2>&1 && sudo apt install libpangocairo-1.0-0 -y
	! dpkg -s python3-xcffib >/dev/null 2>&1 && sudo apt install python3-xcffib -y
	! dpkg -s python3-cairocffi >/dev/null 2>&1 && sudo apt install python3-cairocffi -y
	! dpkg -s pipx >/dev/null 2>&1 && sudo apt install --no-install-recommends pipx -y

	[[ ! -d "$HOME"/src ]] && mkdir "$HOME"/src
	[[ -d "$HOME"/src/picom ]] && rm -rf "$HOME"/src/picom

	git clone https://github.com/yshui/picom.git "$HOME"/src/picom
	cd "$HOME"/src/picom || return 1
	meson setup --buildtype=release build
	ninja -C build
	sudo ninja -C build install

	if ! pipx list 2>&1 | grep -q qtile; then
		pipx install qtile
		pipx inject qtile dbus-next psutil qtile-extras
	fi

	if [ ! -f "$DESKTOPFILE" ]; then
		cat >"$TMPFILE" <<-"EOF"
			[Desktop Entry]
			Name=Qtile
			Comment=Qtile Session
			Type=Application
			Keywords=wm;tiling
			Exec=/home/carlos/.local/bin/qtile start
		EOF

		sudo cp -f "$TMPFILE" "$DESKTOPFILE"
		sudo chmod 644 "$DESKTOPFILE"
	fi
}
##--------------------------------------------------------------------------------------
## Instalar o Hyperland
##

function installHyperland() {
	# Instalar dependências
	! dpkg -s meson >/dev/null 2>&1 && sudo apt install meson -y
	! dpkg -s wget 2>&1 && sudo apt install wget -y
	! dpkg -s build-essential 2>&1 && sudo apt install build-essential -y
	! dpkg -s ninja-build 2>&1 && sudo apt install ninja-build -y
	! dpkg -s cmake-extras 2>&1 && sudo apt install cmake-extras -y
	! dpkg -s cmake 2>&1 && sudo apt install cmake -y
	! dpkg -s gettext 2>&1 && sudo apt install gettext -y
	! dpkg -s gettext-base 2>&1 && sudo apt install gettext-base -y
	! dpkg -s fontconfig 2>&1 && sudo apt install fontconfig -y
	! dpkg -s libfontconfig-dev 2>&1 && sudo apt install libfontconfig-dev -y
	! dpkg -s libffi-dev 2>&1 && sudo apt install libffi-dev -y
	! dpkg -s libxml2-dev 2>&1 && sudo apt install libxml2-dev -y
	! dpkg -s libdrm-dev 2>&1 && sudo apt install libdrm-dev -y
	! dpkg -s libxkbcommon-x11-dev 2>&1 && sudo apt install libxkbcommon-x11-dev -y
	! dpkg -s libxkbregistry-dev 2>&1 && sudo apt install libxkbregistry-dev -y
	! dpkg -s libxkbcommon-dev 2>&1 && sudo apt install libxkbcommon-dev -y
	! dpkg -s libpixman-1-dev 2>&1 && sudo apt install libpixman-1-dev -y
	! dpkg -s libudev-dev 2>&1 && sudo apt install libudev-dev -y
	! dpkg -s libseat-dev 2>&1 && sudo apt install libseat-dev -y
	! dpkg -s seatd 2>&1 && sudo apt install seatd -y
	! dpkg -s libxcb-dri3-dev 2>&1 && sudo apt install libxcb-dri3-dev -y
	! dpkg -s libegl-dev 2>&1 && sudo apt install libegl-dev -y
	! dpkg -s libgles2 2>&1 && sudo apt install libgles2 -y
	! dpkg -s libegl1-mesa-dev 2>&1 && sudo apt install libegl1-mesa-dev -y
	! dpkg -s glslang-tools 2>&1 && sudo apt install glslang-tools -y
	! dpkg -s libinput-bin 2>&1 && sudo apt install libinput-bin -y
	! dpkg -s libinput-dev 2>&1 && sudo apt install libinput-dev -y
	! dpkg -s libxcb-composite0-dev 2>&1 && sudo apt install libxcb-composite0-dev -y
	! dpkg -s libavutil-dev 2>&1 && sudo apt install libavutil-dev -y
	! dpkg -s libavcodec-dev 2>&1 && sudo apt install libavcodec-dev -y
	! dpkg -s libavformat-dev 2>&1 && sudo apt install libavformat-dev -y
	! dpkg -s libxcb-ewmh2 2>&1 && sudo apt install libxcb-ewmh2 -y
	! dpkg -s libxcb-ewmh-dev 2>&1 && sudo apt install libxcb-ewmh-dev -y
	! dpkg -s libxcb-present-dev 2>&1 && sudo apt install libxcb-present-dev -y
	! dpkg -s libxcb-icccm4-dev 2>&1 && sudo apt install libxcb-icccm4-dev -y
	! dpkg -s libxcb-render-util0-dev 2>&1 && sudo apt install libxcb-render-util0-dev -y
	! dpkg -s libxcb-res0-dev 2>&1 && sudo apt install libxcb-res0-dev -y
	! dpkg -s libxcb-xinput-dev 2>&1 && sudo apt install libxcb-xinput-dev -y
	! dpkg -s libtomlplusplus3 2>&1 && sudo apt install libtomlplusplus3 -y
	! dpkg -s xdg-desktop-portal-wlr 2>&1 && sudo apt install xdg-desktop-portal-wlr -y

	[[ ! -d "$HOME"/src ]] && mkdir "$HOME"/src

	git clone --recursive https://github.com/hyprwm/Hyprland "$HOME"/src
	cd "$HOME"/src/Hyprland || exit 1
	make all && sudo make install
}

##--------------------------------------------------------------------------------------
## Instalar o AstroNvim
##

function installAstroNvim() {
	# Remoe backups anteriores
	[[ -d "$HOME"/.config/nvim.bak ]] && rm -rf "$HOME"/.config/nvim.bak
	[[ -d "$HOME"/.local/share/nvim.bak ]] && rm -rf "$HOME"/.local/share/nvim.bak
	[[ -d "$HOME"/.local/state/nvim.bak ]] && rm -rf "$HOME"/.local/state/nvim.bak
	[[ -d "$HOME"/.cache/nvim.bak ]] && rm -rf "$HOME"/.cache/nvim.bak

	# Faz backup das configurações atuais
	[[ -d "$HOME"/.config/nvim ]] && mv "$HOME"/.config/nvim "$HOME"/.config/nvim.bak
	[[ -d "$HOME"/.local/share/nvim ]] && mv "$HOME"/.local/share/nvim "$HOME"/.local/share/nvim.bak
	[[ -d "$HOME"/.local/state/nvim ]] && mv "$HOME"/.local/state/nvim "$HOME"/.local/state/nvim.bak
	[[ -d "$HOME"/.cache/nvim ]] && mv "$HOME"/.cache/nvim "$HOME"/.cache/nvim.bak

	[[ -d "$HOME"/src/neovim ]] && rm -rf "$HOME"/src/neovim

	git clone https://github.com/neovim/neovim "$HOME"/src/neovim
	cd "$HOME"/src/neovim || return 1
	make CMAKE_BUILD_TYPE=Release
	sudo make install
	sudo ln -s /usr/local/bin/nvim /usr/bin/nvim

	git clone --depth 1 https://github.com/AstroNvim/template "$HOME"/.config/nvim
	rm -rf "$HOME"/.config/nvim/.git
	git clone https://github.com/camurim/astronvim_config "$HOME"/.config/nvim/lua/user

	if [ -d "$HOME"/.cargo ]; then
		PATH=$PATH:"$HOME"/.cargo/bin
	fi

	if which cargo && ! which neovide; then
		! dpkg -s libfreetype6-dev >/dev/null 2>&1 && sudo apt-get install libfreetype6-dev -y
		! dpkg -s libfontconfig1-dev >/dev/null 2>&1 && sudo apt-get install libfontconfig1-dev -y
		cargo install --git https://github.com/neovide/neovide
	fi
}

##--------------------------------------------------------------------------------------
## Instalar driver da placa NVidia
##

function installNvidiaDriver() {
	! dpkg -s nvidia-driver >/dev/null 2>&1 && sudo apt-get install nvidia-driver -y
}

##--------------------------------------------------------------------------------------
## Install config files
##

function installDotFiles() {
	if ! which git; then
		return 0
	fi

	[[ ! -d "$HOME"/src/ ]] && mkdir -p "$HOME"/src
	git clone https://github.com/camurim/my-dotfiles.git "$HOME"/src

	cp -r "$HOME"/src/my-dotfiles/.config/* "$HOME"/.config/
	cp -r "$HOME"/src/my-dotfiles/.local/* "$HOME"/.local/
	cp -r "$HOME"/src/my-dotfiles/.dosbox "$HOME"/
	cp -r "$HOME"/src/my-dotfiles/.SpaceVim.d "$HOME"/
	cp -r "$HOME"/src/my-dotfiles/.bash_aliases "$HOME"/
	cp -r "$HOME"/src/my-dotfiles/.bashrc "$HOME"/
}

##--------------------------------------------------------------------------------------
## Menu principal
##

# Os pré-requisitos precisam ser instalados compulsoriamente
installPrerequisites

## Tela inicial

export TERM=ansi
title="Instalação do DistroAmora"

if ! whiptail --title "$title" --yesno "Este programa irá instalar os pacotes necessários para o DistroAmora. \
	Todo o proceso deve demorar vários minutos. Deseja continuar?" 10 78; then
	echo "Até a próxima!"
	exit 1
fi

while true; do
	## Selecionar as opções

	result=$(
		whiptail --title "$title" --checklist \
			"Selecione os pacotes que deseja instalar:" 20 78 9 \
			"CREATE_DIRS" "Criar estrutura de diretórios padrão." ON \
			"INSTALL_PL_FONTS" "Instalar fontes PowerLine." ON \
			"INSTALL_LIBRARIES" "Instalar bibliotecas." ON \
			"INSTALL_DEV_TOOL" "Instalar ferramentas de desenvolvimento." ON \
			"INSTALL_ASTRO_NVIM" "Instalar o AstroNvim." ON \
			"INSTALL_UTILITIES" "Instalar utilitários." ON \
			"INSTALL_ACCESSORIES" "Instalar acessórios." ON \
			"INSTALL_QTILE" "Instalar o Qtile." ON \
			"INSTALL_HYPERLAND" "Instalar o Hyperland." ON \
			"INSTALL_FISH_SHELL" "Instalar o Fish Shell." ON \
			"INSTALL_DOT_FILES" "Instalar os 'dot-files' padrões." ON \
			"INSTALL_TECH_SCI_SOFTWARE" "Instalar softwares técnicos ou científicos." ON \
			"INSTALL_NVIDIA_DRIVER" "Instalar drivers da GPU NVidia." ON \
			3>&2 2>&1 1>&3
	)

	if [ -z "$result" ]; then
		echo "Até a próxima!"
		exit 1
	fi

	IFS=' ' read -ra arraymenu <<<"$result"

	##--------------------------------------------------------------------------------------
	## Cria diretórios do usuário
	##

	if [[ "${arraymenu[*]}" =~ 'CREATE_DIRS' ]]; then
		configUserDirectories
	fi

	##--------------------------------------------------------------------------------------
	## Cria diretórios do usuário
	##

	if [[ "${arraymenu[*]}" =~ 'INSTALL_PL_FONTS' ]]; then
		installPlFonts
	fi

	##--------------------------------------------------------------------------------------
	## Instala bibliotecas
	##

	if [[ "${arraymenu[*]}" =~ 'INSTALL_LIBRARIES' ]]; then
		installLibraries
	fi

	##--------------------------------------------------------------------------------------
	## Instalar ferramentas de desenvolvimento
	##

	if [[ "${arraymenu[*]}" =~ 'INSTALL_DEV_TOOL' ]]; then
		installDevTools
	fi

	##--------------------------------------------------------------------------------------
	## Instalar o AstroNvim
	##

	if [[ "${arraymenu[*]}" =~ 'INSTALL_ASTRO_NVIM' ]]; then
		installAstroNvim
	fi

	##--------------------------------------------------------------------------------------
	## Instalar utilitários
	##

	if [[ "${arraymenu[*]}" =~ 'INSTALL_UTILITIES' ]]; then
		installUtilities
	fi

	##--------------------------------------------------------------------------------------
	## Instalar acessórios
	##

	if [[ "${arraymenu[*]}" =~ 'INSTALL_ACCESSORIES' ]]; then
		installAccessories
	fi

	##--------------------------------------------------------------------------------------
	## Instalar o QTIle
	##

	if [[ "${arraymenu[*]}" =~ 'INSTALL_QTILE' ]]; then
		installQtile
	fi

	##--------------------------------------------------------------------------------------
	## Instalar o Hyperland
	##

	if [[ "${arraymenu[*]}" =~ 'INSTALL_HYPERLAND' ]]; then
		installHyperland
	fi

	##--------------------------------------------------------------------------------------
	## Instalar o Fish Shell
	##

	if [[ "${arraymenu[*]}" =~ 'INSTALL_FISH_SHELL' ]]; then
		installFishShell
	fi

	##--------------------------------------------------------------------------------------
	## Instalar os arquivos de configuração padrão
	##

	if [[ "${arraymenu[*]}" =~ 'INSTALL_DOT_FILES' ]]; then
		installDotFiles
	fi

	##--------------------------------------------------------------------------------------
	## Instalar softwares técnicos e científicos
	##

	if [[ "${arraymenu[*]}" =~ 'INSTALL_TECH_SCI_SOFTWARE' ]]; then
		installTechSciSoftware
	fi

	##--------------------------------------------------------------------------------------
	## Instalar Drivers da GPU NVidia
	##

	if [[ "${arraymenu[*]}" =~ 'INSTALL_NVIDIA_DRIVER' ]]; then
		installNvidiaDriver
	fi
done
