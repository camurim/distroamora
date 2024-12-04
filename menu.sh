#!/usr/bin/env bash

##
## Variáveis gerais
##

TMP=${TMP:-/tmp}

##------------------------------------------------------------------------------------
## Função para barra de progresso
##

bar_size=40
bar_char_done="#"
bar_char_todo="-"
bar_percentage_scale=2

function show_progress() {
	current="$1"
	total="$2"

	# calculate the progress in percentage
	percent=$(bc <<<"scale=$bar_percentage_scale; 100 * $current / $total")
	# The number of done and todo characters
	done=$(bc <<<"scale=0; $bar_size * $percent / 100")
	todo=$(bc <<<"scale=0; $bar_size - $done")

	# build the done and todo sub-bars
	done_sub_bar=$(printf "%${done}s" | tr " " "${bar_char_done}")
	todo_sub_bar=$(printf "%${todo}s" | tr " " "${bar_char_todo}")

	# output the bar
	echo -ne "\rProgress : [${done_sub_bar}${todo_sub_bar}] ${percent}%"

	if [ "$total" -eq "$current" ]; then
		echo -e "\nDONE"
	fi
}

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
	[[ ! -d "$HOME"/Documentos/docs-archive ]] && ln -s "$HOME"/google-drive/docs-archive "$HOME"/Documentos/docs
	[[ ! -d "$HOME"/Documentos/LTS ]] && ln -s "$HOME"/google-drive/LTS "$HOME"/Documentos/docs
	[[ ! -d "$HOME"/Documentos/projects ]] && ln -s "$HOME"/google-drive/projects "$HOME"/Documentos/docs
	[[ ! -d "$HOME"/keyring ]] && ln -s "$HOME"/google-drive/keyring "$HOME"/keyring
	[[ ! -d "$HOME"/scripts ]] && ln -s "$HOME"/google-drive/scripts "$HOME"/scripts
}

##------------------------------------------------------------------------------------
## Instalar pré-requisitos
##

function installPrerequisites() {
	sudo apt-get update -y
	sudo apt-get upgrade -y
	[[ $(dpkg -s whiptail >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install whiptail -y
	[[ $(dpkg -s wget >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install wget -y
	[[ $(dpkg -s curl >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install curl -y
	[[ $(dpkg -s rclone >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install rclone -y
	[[ $(dpkg -s gawk >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install gawk -y
	[[ $(dpkg -s temurin-8-jdk >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install temurin-8-jdk -y
	[[ $(dpkg -s temurin-17-jdk >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install temurin-17-jdk -y
	[[ $(dpkg -s temurin-23-jdk >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install temurin-23-jdk -y
	[[ $(dpkg -s libreoffice >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install libreoffice --no-install-recommends -y
}

##------------------------------------------------------------------------------------
## Instalar Fontes
##

function installFonts() {
	[[ $(dpkg -s powerline >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install powerline -y
	[[ $(dpkg -s fonts-powerline >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install fonts-powerline -y
}

##--------------------------------------------------------------------------------------
## Instalar ferramentas de desenvolvimento
##

function installDevTools() {
	[[ $(dpkg -s build-essential >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install build-essential -y
	[[ $(dpkg -s fakeroot >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install fakeroot -y
	[[ $(dpkg -s devscripts >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install devscripts -y
	[[ $(dpkg -s make >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install make -y
	[[ $(dpkg -s cmake >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install cmake -y
	[[ $(dpkg -s ninja-build >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install ninja-build -y
	[[ $(dpkg -s meson >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install meson -y
	[[ $(dpkg -s linux-headers-"$(uname -r)" >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install linux-headers-"$(uname -r)" -y
	[[ $(dpkg -s libglvnd-dev >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install libglvnd-dev -y
	[[ $(dpkg -s pkg-config >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install pkg-config -y
	[[ $(dpkg -s vim >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install vim -y
	[[ $(dpkg -s neovim >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install neovim -y
	[[ $(dpkg -s git >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install git -y
	[[ $(dpkg -s gh >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install gh -y
	[[ $(dpkg -s python3-all >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install python3-all -y
	python3 -m ensurepip --upgrade
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

##--------------------------------------------------------------------------------------
## Instalar utilitários
##

function installUtils() {
	[[ $(dpkg -s alacritty >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install alacritty -y
	[[ $(dpkg -s keepassxc >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install keepassxc -y
	[[ $(dpkg -s inotify-tools >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install inotify-tools -y
	[[ $(dpkg -s lolcat >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install lolcat -y
	[[ $(dpkg -s kitty >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install kitty -y
	[[ $(dpkg -s zenity >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install zenity -y
	[[ $(dpkg -s scrot >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install scrot -y
	[[ $(dpkg -s flameshot >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install flameshot -y
	[[ $(dpkg -s gromit >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install gromit -y
	[[ $(dpkg -s gromit-mpx >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install gromit-mpx -y
	[[ $(dpkg -s feh >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install feh -y
	[[ $(dpkg -s magnus >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install magnus -y
	[[ $(dpkg -s qalculate-gtk >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install qalculate-gtk -y
	[[ $(dpkg -s mpv >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install mpv -y
	[[ $(dpkg -s vlc >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install vlc -y
	[[ $(dpkg -s cmus >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install cmus -y
	[[ $(dpkg -s deadbeef >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install deadbeef -y
	[[ $(dpkg -s exa >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install exa -y
	[[ $(dpkg -s netcat >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install netcat -y
	[[ $(dpkg -s netcat-traditional >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install netcat-traditional -y
	[[ $(dpkg -s prettyping >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install prettyping -y
	[[ $(dpkg -s nala >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install nala -y
	[[ $(dpkg -s htop >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install htop -y
	[[ $(dpkg -s rofi >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install rofi -y
	[[ $(dpkg -s newsboat >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install newsboat -y
	[[ $(dpkg -s pulsemixer >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install pulsemixer -y
	[[ $(dpkg -s neofetch >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install neofetch -y
	[[ $(dpkg -s screenfetch >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install screenfetch -y
	[[ $(dpkg -s mp3info >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install mp3info -y
	[[ $(dpkg -s trash-cli >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install trash-cli -y
	[[ $(dpkg -s calcurse >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install calcurse -y
	[[ $(dpkg -s fzf >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install fzf -y
	[[ $(dpkg -s f3 >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install f3 -y
	[[ $(dpkg -s filezilla >/dev/null 2>&1) -ne 0 ]] && sudo apt-get install filezilla -y
}

##--------------------------------------------------------------------------------------
## Instalar QTile
##

function installQtile() {
	sudo apt install libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev meson ninja-build uthash-dev -y
	sudo apt install --no-install-recommends pipx -y
	sudo apt install xserver-xorg-core xserver-xorg-input-libinput xinit libpangocairo-1.0-0 python3-xcffib python3-cairocffi -y

	[[ ! -d "$HOME"/src ]] && mkdir "$HOME"/src
	git clone https://github.com/yshui/picom.git "$HOME"/src
	cd "$HOME"/src/picom || return 1
	meson setup --buildtype=release build
	ninja -C build
	ninja -C build install

	pipx install qtile
	pipx inject qtile dbus-next psutil
	pipx inject qtile qtile-extras
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
## Instalação
##

installPrerequisites
installdevTools

##--------------------------------------------------------------------------------------
##
##
