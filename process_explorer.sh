#!/bin/bash

# Définition des couleurs
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

function show_process_explorer_options() {
	clear
	echo -n "
  ___ ___  ___   ___ ___ ___ ___   _____  _____ _    ___  ___ ___ ___ 
 | _ \ _ \/ _ \ / __| __/ __/ __| | __\ \/ / _ \ |  / _ \| _ \ __| _ \ 
 |  _/   / (_) | (__| _|\__ \__ \ | _| >  <|  _/ |_| (_) |   / _||   /
 |_| |_|_\\\\___/ \___|___|___/___/ |___/_/\_\_| |____\___/|_|_\___|_|_\ 
                                                                    
"
	echo "1. Identifier tous les processus présents sur le système et indiquer leur propriétaire"
	echo "2. Identifier uniquement les processus actifs et indiquer leur propriétaire"
	echo "3. Identifier les processus appartenant à un utilisateur donné en paramètre"
	echo "4. Identifier les processus consommant le plus de mémoire et indiquer leur propriétaire"
	echo "5. Identifier les processus dont le nom contient une chaine de caractères (définie en paramètre) et indiquer leur propriétaire"
	# + Chaque résultat de sortie doit être sauvegardé dans un fichier (résultats précédent doivent pas être supprimés + trié par date)
	echo "6. *A définir*"
	echo "R. Retour"
	echo "Q. Quitter"
}

function write_logs() {
	echo -e "--------------------------------------------------------------------------------------------------------------------------" >> logs.txt
	echo -e "$*" "						$(date)" >> logs.txt 
	echo -e "--------------------------------------------------------------------------------------------------------------------------" >> logs.txt
}

# 1. Identifier tous les processus présents sur le système et indiquer leur propriétaire
function show_all_processes() {
	# sortie="Tous les processus présents sur le système : $(ps -ef)"
	# echo -e $sortie
	# echo ""
	# write_logs $sortie

	# Affichage de l'en-tête en couleurs
	printf "${YELLOW}%-7s ${GREEN}%-15s ${YELLOW}%-30s${NC}\n" "PID" "Propriétaire" "Nom du processus"
	echo "--------------------------------------------------------------"

	# Boucle sur tous les processus en cours d'exécution
	for pid in $(pgrep -d ' ' ""); do
		# Obtient le nom d'utilisateur du propriétaire du processus
		user=$(ps -o user= -p $pid)
		# Obtient le nom du processus
		process=$(ps -o comm= -p $pid)

		# Affiche les informations sur le processus en couleurs
		printf "${YELLOW}%-7s ${GREEN}%-15s ${YELLOW}%-30s${NC}\n" "$pid" "$user" "$process"
	done
}

# 2. Identifier uniquement les processus actifs et indiquer leur propriétaire
function show_active_processes() {
	# sortie="Tous les processus actifs sur le système : $(ps -ef | grep -v 'grep')"
	# echo -e $sortie
	# echo ""
	# write_logs $sortie

	# Affichage de l'en-tête en couleurs
	printf "${YELLOW}%-7s ${GREEN}%-15s ${YELLOW}%-30s${NC}\n" "PID" "Propriétaire" "Nom du processus"
	echo "--------------------------------------------------------------"

	# Boucle sur tous les processus en cours d'exécution
	for pid in $(pgrep -d ' ' ""); do
		# Obtient le nom d'utilisateur du propriétaire du processus
		user=$(ps -o user= -p $pid)
		# Obtient le nom du processus
		process=$(ps -o comm= -p $pid)

		# Vérifie si le processus est actif
		if ps -p $pid > /dev/null; then
			# Affiche les informations sur le processus en couleurs
			printf "${GREEN}%-7s ${YELLOW}%-15s ${GREEN}%-30s${NC}\n" "$pid" "$user" "$process"
		fi
	done
}

# 3. Identifier les processus appartenant à un utilisateur donné en paramètre
function show_processes_by_user() {
	read -p "Entrez le nom d'utilisateur : " user
	sortie="Tous les processus appartenant à l'utilisateur $user : $(ps -ef | grep $user)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

# 4. Identifier les processus consommant le plus de mémoire et indiquer leur propriétaire
function show_processes_by_memory() {
	sortie="Tous les processus consommant le plus de mémoire : $(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

# 5. Identifier les processus dont le nom contient une chaine de caractères (définie en paramètre) et indiquer leur propriétaire
function show_processes_by_name() {
	read -p "Entrez le nom du processus : " process_name
	sortie="Tous les processus dont le nom contient une chaine de caractères (définie en paramètre) : $(ps -ef | grep $process_name)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

function selection() {
	while true; do 
		echo -e -n "\n${GREEN}Entrez votre choix : ${NC}"
		read choice
		case $choice in
			1) show_all_processes ;;
			2) show_active_processes ;;
			3) show_processes_by_user ;;
			4) show_processes_by_memory ;;
			5) show_processes_by_name ;;
			6) echo "A définir" ;;
			r|R) bash menu.sh 
			break ;;
			q|Q) exit 0;;
			*) echo "Erreur : choix invalide" 
			selection
			break;;
		esac
	done
}

show_process_explorer_options
selection