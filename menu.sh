#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' 

# Fonction pour afficher le menu principal
function show_menu() {
	clear
	echo "
    ____               _      __     ____  ___   _____ __  __
   / __ \_________    (_)__  / /_   / __ )/   | / ___// / / /
  / /_/ / ___/ __ \  / / _ \/ __/  / __  / /| | \__ \/ /_/ / 
 / ____/ /  / /_/ / / /  __/ /_   / /_/ / ___ |___/ / __  /  
/_/   /_/   \____/_/ /\___/\__/  /_____/_/  |_/____/_/ /_/   
                /___/                                        

by AYDIN Isamettin & Feucht Joé

"
	echo "1. File explorer"
	echo "2. Process epxlorer"
	echo "3. Services explorer"
	echo -e "Q. Quitter\n"
}

show_menu

while true; do
	echo -e -n "${GREEN}Choisissez une option : ${NC} "
	read choice
	case $choice in
	1)
		bash file_explorer.sh
		break
		;;
	2)
		bash process_explorer.sh
		break
		;;
	3)
		bash services_explorer.sh
		break
		;;
	q|Q)
		exit 0
		;;
	*)
		echo "Option invalide. Veuillez choisir 1, 2 ou 3."
		;;
	esac
done
