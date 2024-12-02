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

	if [ $total -eq $current ]; then
		echo -e "\nDONE"
	fi
}

##------------------------------------------------------------------------------------
## Instalar pré-requisitos
##

function installPrerequisites() {
	[[ $(dpkg -s whiptail >/dev/null 2>&1) -ne 0 ]] && apt-get install whiptail -y
	[[ $(dpkg -s gawk >/dev/null 2>&1) -ne 0 ]] && apt-get install gawk -y
	[[ $(dpkg -s postgresql-13 >/dev/null 2>&1) -ne 0 ]] && apt-get install postgresql-13 -y
	[[ $(dpkg -s libreoffice >/dev/null 2>&1) -ne 0 ]] && apt-get install libreoffice --no-install-recommends -y
}
