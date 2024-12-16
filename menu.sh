#!/usr/bin/env bash

##
## Variáveis gerais
##

TMP=${TMP:-/tmp}

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
	! dpkg -s unzip  >/dev/null 2>&1 && sudo apt-get install unzip -y
	! dpkg -s libreoffice >/dev/null 2>&1 && sudo apt-get install libreoffice --no-install-recommends -y
	sudo apt-get install cabextract libmspack0 ttf-mscorefonts-installer -y
}

##------------------------------------------------------------------------------------
## Instalar bibliotecas
##

function installLibraries() {
	sudo apt install libx11-dev libx11-xcb-dev libxext6 libxmu-dev libxmuu-dev libxext-dev libxcb1-dev libxcb-damage0-dev -y
	sudo apt install libxcb-dpms0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev -y
	sudo apt install libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-glx0-dev libpixman-1-dev -y
	sudo apt install libdbus-1-dev libconfig-dev libgl-dev libegl-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev -y
	sudo apt install libicu-dev libncurses-dev libgmp-dev zlib1g-dev libperl-dev libedit-dev libpam0g-dev libpam-dev libkrb5-dev -y
	sudo apt install libldap2-dev libxslt1-dev libossp-uuid-dev bison flex opensp tcl-dev xsltproc install libperl-dev libedit-dev -y
	sudo apt install libpam0g-dev libpam-dev libkrb5-dev libldap2-dev libxslt1-dev libossp-uuid-dev bison flex opensp tcl-dev xsltproc -y
	sudo apt install dpkg-dev docbook-dsssl docbook libreadline-dev libasound2-dev libasound2 libalsaplayer-dev sdl2 sdl2_image -y
	sudo apt install libsdl2-image-dev gcc-multilib bsdtar libarchive-tools patchelf rpm2cpio lib32ncurses-dev libasound2-dev -y
	sudo apt install libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxcursor-dev libxinerama-dev -y
}

##------------------------------------------------------------------------------------
## Instalar Fontes
##

function installPlFonts() {
	! dpkg -s powerline >/dev/null 2>&1 && sudo apt-get install powerline -y
	! dpkg -s fonts-powerline >/dev/null 2>&1 && sudo apt-get install fonts-powerline -y

	bash -c "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"
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

	if [ ! -f "$HOME"/.cargo/bin/cargo ]; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
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

	if ! which yt-dlp; then
		pip3 install yt-dlp --break-system-packages
	fi

	if ! which glow; then
		sudo mkdir -p /etc/apt/keyrings
		curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
		echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
		sudo apt update && sudo apt install glow
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
	! dpkg -s dosbox  >/dev/null 2>&1 && sudo apt-get install dosbox -y
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
	sudo apt install cmake libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev meson ninja-build uthash-dev -y
	sudo apt install --no-install-recommends pipx -y
	sudo apt install xserver-xorg-core xserver-xorg-input-libinput xinit libpangocairo-1.0-0 python3-xcffib python3-cairocffi -y

	[[ ! -d "$HOME"/src ]] && mkdir "$HOME"/src
	git clone https://github.com/yshui/picom.git "$HOME"/src/picom
	cd "$HOME"/src/picom || return 1
	meson setup --buildtype=release build
	ninja -C build
	sudo ninja -C build install

	pipx install qtile
	pipx inject qtile dbus-next psutil qtile-extras
}

##--------------------------------------------------------------------------------------
## Instalar o AstroNvim
##

function installAstroNvim() {
	[[ -d "$HOME"/.config/nvim ]] && mv "$HOME"/.config/nvim ~/.config/nvim.bak
	[[ -d "$HOME"/.local/share/nvim ]] && mv "$HOME"/.local/share/nvim ~/.local/share/nvim.bak
	[[ -d "$HOME"/.local/state/nvim ]] && mv "$HOME"/.local/state/nvim ~/.local/state/nvim.bak
	[[ -d "$HOME"/.cache/nvim ]] && mv "$HOME"/.cache/nvim ~/.cache/nvim.bak

	[[ -d "$HOME"/src/neovim ]] && rm -rf "$HOME"/src/neovim

	git clone https://github.com/neovim/neovim "$HOME"/src/neovim
	cd "$HOME"/src/neovim || return 1
	make CMAKE_BUILD_TYPE=Release
	sudo make install
	sudo ln -s /usr/local/bin/nvim /usr/bin/nvim

	git clone --depth 1 https://github.com/AstroNvim/template "$HOME"/.config/nvim
	rm -rf "$HOME"/.config/nvim/.git
	git clone https://github.com/camurim/astronvim_config "$HOME"/.config/nvim/lua/user
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

while true 
do
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

