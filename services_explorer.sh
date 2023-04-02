#!/bin/bash

# Définition des couleurs
SERVICE_COLOR='\033[0;36m'
STATUS_COLOR='\033[0;32m'
NC='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'


function show_services_explorer_options() {
	clear
	echo -n "
  ___ ___ _____   _____ ___ ___   _____  _____ _    ___  ___ ___ ___ 
 / __| __| _ \ \ / /_ _/ __| __| | __\ \/ / _ \ |  / _ \| _ \ __| _ \ 
 \__ \ _||   /\ V / | | (__| _|  | _| >  <|  _/ |_| (_) |   / _||   /
 |___/___|_|_\ \_/ |___\___|___| |___/_/\_\_| |____\___/|_|_\___|_|_\ 
                                                                     
"
	echo "1. Identifier les services disponibles/installés sur le système"
	echo "2. Identifier les services actifs sur le système"
	echo "3. Identifier le statut d’un service dont le nom contient une chaine de caractères (définie en paramètre)"
	echo "4. *A définir*"
	echo "R. Retour"
	echo "Q. Quitter"
}

function write_logs() {
    LOGS_DIR="/home/$(whoami)/script_logs"
    LOGS_FILE="$LOGS_DIR/logs.txt"
	echo -e "Logs : $LOGS_FILE"

	if [ ! -d "$LOGS_DIR" ]; then
        mkdir -p "$LOGS_DIR"
    fi

    echo -e "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" >> "$LOGS_FILE"
    echo -e "$(date) |" " $*" >> "$LOGS_FILE"
    echo -e "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" >> "$LOGS_FILE"
}

# 1. Identifier les services disponibles/installés sur le système
function show_all_services() {

	# Boucle jusqu'à ce que l'utilisateur appuie sur la touche "Q"
	while true; do
		clear
		show_services_explorer_options
		echo -e "\nVous avez choisi l'option 1 \n"

		# Affiche l'en-tête avec les couleurs pour chaque colonne
		printf "${SERVICE_COLOR}%-40s${NC}  	| ${STATUS_COLOR}%-s${NC}\n" "Nom du service" "Statut"
		printf "${NC}-----------------------------------------------------------------${NC}\n"

		services=$(systemctl list-unit-files --type=service --state=enabled,disabled | awk '{print $1}' | grep -v "@" | sort)

		# Affiche chaque service avec des couleurs différentes pour chaque colonne
		for service in $services; do
			# Obtient le statut du service
			status=$(systemctl is-active $service)

			# Affichage sous forme de tableau
			if [[ "$status" = "active" ]]; then
				printf "${SERVICE_COLOR}%-40s${NC}  	| ${GREEN}%-s${NC}\n" "$service" "$status"
			else
				printf "${SERVICE_COLOR}%-40s${NC}  	| ${RED}%-s${NC}\n" "$service" "$status"
			fi
		done

		echo ""
		# Affiche un timer jusqu'à ce que l'utilisateur appuie sur la touche "Q"
		for i in {30..1}; do
			printf "\r${YELLOW}Actualisation dans %2d secondes... Appuyez sur Q pour quitter.${NC}" "$i"
			read -s -n 1 -t 1 key
			if [[ $key = "q" ]] || [[ $key = "Q" ]]; then
				printf "\r${NC}"
				return
			fi
		done
	done

}

# 2. Identifier les services actifs sur le système
function show_active_services() {

	# Boucle jusqu'à ce que l'utilisateur appuie sur la touche "Q"
	while true; do
		clear
		show_services_explorer_options
		echo -e "\nVous avez choisi l'option 2 \n"

		# Affiche l'en-tête avec les couleurs pour chaque colonne
		printf "${SERVICE_COLOR}%-40s${NC}  	| ${STATUS_COLOR}%-s${NC}\n" "Nom du service" "Statut"
		printf "${NC}-----------------------------------------------------------------${NC}\n"

		services=$(systemctl list-unit-files --type=service --state=enabled | awk '{print $1}' | grep -v "@" | sort)

		# Affiche chaque service actif avec des couleurs différentes pour chaque colonne
		for service in $services; do
			# Obtient le statut du service
			status=$(systemctl is-active $service)

			if [[ "$status" == "active" ]]; then
			# Affichage sous forme de tableau
				printf "${SERVICE_COLOR}%-40s${NC}  	| ${STATUS_COLOR}%-s${NC}\n" "$service" "$status"
			fi
		done

		echo ""
		# Affiche un timer jusqu'à ce que l'utilisateur appuie sur la touche "Q"
		for i in {30..1}; do
			printf "\r${YELLOW}Actualisation dans %2d secondes... Appuyez sur Q pour quitter.${NC}" "$i"
			read -s -n 1 -t 1 key
			if [[ $key = "q" ]] || [[ $key = "Q" ]]; then
				printf "\r${NC}"
				return
			fi
		done
	done

}

# 3. Identifier le statut d’un service dont le nom contient une chaine de caractères (définie en paramètre)
function show_services_by_name() {

	# Lecture de la chaîne de caractères pour le filtre
	echo -n -e "${GREEN}Rechercher des services contenant (laissez vide pour tout afficher) : ${NC}"
	read filter_string

	# Boucle jusqu'à ce que l'utilisateur appuie sur la touche "Q"
	while true; do
		clear
		show_services_explorer_options
		echo -e "\nVous avez choisi l'option 3 avec le filtre '${filter_string}'\n"

		# Affiche l'en-tête avec les couleurs pour chaque colonne
		printf "${SERVICE_COLOR}%-40s${NC}  	| ${STATUS_COLOR}%-s${NC}\n" "Nom du service" "Statut"
		printf "${NC}-----------------------------------------------------------------${NC}\n"

		services=$(systemctl list-unit-files --type=service --state=enabled,disabled | awk '{print $1}' | grep -v "@" | sort)

		# Boucle sur tous les services
		for service in $services; do
			# Si le filtre n'est pas vide et que le nom du service ne contient pas la chaîne de caractères, on passe au service suivant
			if [[ -n "$filter_string" && ! "$service" =~ "$filter_string" ]]; then
				continue
			fi

			# Obtient le statut du service
			status=$(systemctl is-active $service)

			# Détermine la couleur à utiliser pour le statut
			if [[ "$status" == "active" ]]; then
				status_color="${GREEN}$status${NC}"
			else
				status_color="${RED}$status${NC}"
			fi

			# Affichage sous forme de tableau
			printf "${SERVICE_COLOR}%-40s${NC}  	| $status_color\n" "$service"
		done

		echo ""
		# Affiche un timer jusqu'à ce que l'utilisateur appuie sur la touche "Q"
		for i in {30..1}; do
			printf "\r${YELLOW}Actualisation dans %2d secondes... Appuyez sur Q pour quitter.${NC}" "$i"
			read -s -n 1 -t 1 key
			if [[ $key = "q" ]] || [[ $key = "Q" ]]; then
				printf "\r${NC}"
				return
			fi
		done
	done
}

function selection() {
	while true; do 
		echo -e -n "\n${GREEN}Entrez votre choix : ${NC}"
		read choice
		echo ""
		case $choice in
			1) show_all_services;;
			2) show_active_services;;
			3) show_services_by_name;;
			4) echo "A définir";;
			r|R) bash menu.sh 
			break ;;
			q|Q) exit 0;;
			*) echo "Erreur : choix invalide" 
			selection
			break;;
		esac
	done
}

show_services_explorer_options
selection