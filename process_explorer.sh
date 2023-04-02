#!/bin/bash

# Définition des couleurs
PID_COLOR='\033[0;36m'
OWNER_COLOR='\033[0;32m'
PROCESS_COLOR='\033[0;33m'
NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
MEMORY_COLOR='\033[1;35m'


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

# 1. Identifier tous les processus présents sur le système et indiquer leur propriétaire
function show_all_processes() {
	# sortie="Tous les processus présents sur le système : $(ps -ef)"
	# echo -e $sortie
	# echo ""
	# write_logs $sortie

    # Boucle jusqu'à ce que l'utilisateur appuie sur la touche "Q"
    while true; do
        clear
        show_process_explorer_options
        echo -e "\nVous avez choisi l'option 1 \n"

        # Affiche l'en-tête avec les couleurs pour chaque colonne
        printf "${PID_COLOR}%-6s${NC} | ${OWNER_COLOR}%-14s${NC}  	| ${PROCESS_COLOR}%-s${NC}\n" "PID" "Propriétaire" "Nom du processus"
        printf "${NC}-----------------------------------------------------------------${NC}\n"

        pids=$(find /proc -maxdepth 1 -type d -name '[0-9]*' -printf '%f\n' | sort -n)

        # Affiche chaque processus avec des couleurs différentes pour chaque colonne
        for pid in $pids; do
            # Obtient le nom du propriétaire du processus
            owner=$(ps -o user= -p $pid 2>/dev/null)

            if [[ -n "$owner" ]]; then
                # Obtient le nom du processus correspondant au PID
                process=$(ps -o comm= -p $pid 2>/dev/null)

                # Affiche le PID, le propriétaire et le nom du processus dans un format esthétique avec des couleurs différentes pour chaque colonne
                printf "${PID_COLOR}%-6s${NC} | ${OWNER_COLOR}%-14s${NC} 	| ${PROCESS_COLOR}%-s${NC}\n" "$pid" "$owner" "$process"
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

# 2. Identifier uniquement les processus actifs et indiquer leur propriétaire
function show_active_processes() {
	# sortie="Tous les processus actifs sur le système : $(ps -ef | grep -v 'grep')"
	# echo -e $sortie
	# echo ""
	# write_logs $sortie

	# Boucle jusqu'à ce que l'utilisateur appuie sur la touche "Q"
	while true; do
		clear
		show_process_explorer_options
		echo -e "\nVous avez choisi l'option 2 \n"

		# Affiche l'en-tête avec les couleurs pour chaque colonne
		printf "${PID_COLOR}%-6s${NC} | ${OWNER_COLOR}%-14s${NC}  	| ${PROCESS_COLOR}%-s${NC}\n" "PID" "Propriétaire" "Nom du processus"
		printf "${NC}-----------------------------------------------------------------${NC}\n"

		# Obtient tous les PIDs des processus actifs
		pids=$(ps -eo pid=)

		# Affiche chaque processus actif avec des couleurs différentes pour chaque colonne
		for pid in $pids; do
			# Obtient le nom du propriétaire du processus
			owner=$(ps -o user= -p $pid 2>/dev/null)

			if [[ -n "$owner" ]]; then
				# Obtient le nom du processus correspondant au PID
				process=$(ps -o comm= -p $pid 2>/dev/null)

				# Affiche le PID, le propriétaire et le nom du processus dans un format esthétique avec des couleurs différentes pour chaque colonne
				printf "${PID_COLOR}%-6s${NC} | ${OWNER_COLOR}%-14s${NC} 	| ${PROCESS_COLOR}%-s${NC}\n" "$pid" "$owner" "$process"
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

# 3. Identifier les processus appartenant à un utilisateur donné en paramètre
function show_processes_by_user() {
#	read -p "Entrez le nom d'utilisateur : " user
#	sortie="Tous les processus appartenant à l'utilisateur $user : $(ps -ef | grep $user)"
#	echo -e $sortie
#	echo ""
#	write_logs $sortie
	


	# Obtient l'utilisateur dont les processus seront affichés
	echo -n -e "${GREEN}Entrez le nom d'utilisateur : ${NC}"
	read username

	# Boucle jusqu'à ce que l'utilisateur appuie sur la touche "Q"
	while true; do
		clear
		show_process_explorer_options
		echo -e "\nAffichage des processus de l'utilisateur ${OWNER_COLOR}$username${NC}\n"

		# Affiche l'en-tête avec les couleurs pour chaque colonne
		printf "${PID_COLOR}%-6s${NC} | ${OWNER_COLOR}%-14s${NC}  	| ${PROCESS_COLOR}%-s${NC}\n" "PID" "Propriétaire" "Nom du processus"
		printf "${NC}-----------------------------------------------------------------${NC}\n"

		pids=$(find /proc -maxdepth 1 -type d -name '[0-9]*' -printf '%f\n' | sort -n)

		# Affiche chaque processus de l'utilisateur avec des couleurs différentes pour chaque colonne
		for pid in $pids; do
			# Obtient le nom du propriétaire du processus
			owner=$(ps -o user= -p $pid 2>/dev/null)

			if [[ "$owner" == "$username" ]]; then
				# Obtient le nom du processus correspondant au PID
				process=$(ps -o comm= -p $pid 2>/dev/null)

				# Affiche le PID, le propriétaire et le nom du processus dans un format esthétique avec des couleurs différentes pour chaque colonne
				printf "${PID_COLOR}%-6s${NC} | ${OWNER_COLOR}%-14s${NC} 	| ${PROCESS_COLOR}%-s${NC}\n" "$pid" "$owner" "$process"
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

# 4. Identifier les processus consommant le plus de mémoire et indiquer leur propriétaire
function show_processes_by_memory() {
	# sortie="Tous les processus consommant le plus de mémoire : $(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head)"
	# echo -e $sortie
	# echo ""
	# write_logs $sortie

while true; do
    clear
    show_process_explorer_options
    echo -e "\nVous avez choisi l'option 4 \n"

    # Affiche l'en-tête avec les couleurs pour chaque colonne
    printf "${PID_COLOR}%-6s${NC} | ${OWNER_COLOR}%-14s${NC} 		| ${MEMORY_COLOR}%-12s${NC}  | ${PROCESS_COLOR}%-s${NC}\n" "PID" "Propriétaire" "Mémoire" "Nom du processus"
    printf "${NC}---------------------------------------------------------------${NC}\n"

    # Trie les processus par consommation de mémoire
    sorted_pids=$(ps axo pid,user,pmem,comm | sort -k 3 -r | awk '{print $1}')

    # Affiche chaque processus avec des couleurs différentes pour chaque colonne
    for pid in $sorted_pids; do
        # Obtient le nom du propriétaire du processus
        owner=$(ps -o user= -p $pid 2>/dev/null)

        if [[ -n "$owner" ]]; then
            # Obtient la quantité de mémoire utilisée par le processus
            memory=$(ps -o pmem= -p $pid 2>/dev/null)

            # Obtient le nom du processus correspondant au PID
            process=$(ps -o comm= -p $pid 2>/dev/null)

            # Affiche le PID, le propriétaire, la quantité de mémoire utilisée et le nom du processus dans un format esthétique avec des couleurs différentes pour chaque colonne
            printf "${PID_COLOR}%-6s${NC} | ${OWNER_COLOR}%-14s${NC} 	| ${MEMORY_COLOR}%-12s${NC} | ${PROCESS_COLOR}%-s${NC}\n" "$pid" "$owner" "$memory" "$process"
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

# 5. Identifier les processus dont le nom contient une chaine de caractères (définie en paramètre) et indiquer leur propriétaire
function show_processes_by_name() {
	# read -p "Entrez le nom du processus : " process_name
	# sortie="Tous les processus dont le nom contient une chaine de caractères (définie en paramètre) : $(ps -ef | grep $process_name)"
	# echo -e $sortie
	# echo ""
	# write_logs $sortie

	# Récupération de la chaîne de caractères en entrée
	echo -n -e "${GREEN}Rechercher des processus contenant (laissez vide pour tout afficher) : ${NC}"
	read filter

	# Boucle jusqu'à ce que l'utilisateur appuie sur la touche "Q"
	while true; do
		clear
		show_process_explorer_options
		echo -e "\nVous avez choisi l'option 5 avec le filtre '${filter}' \n"

		# Affiche l'en-tête avec les couleurs pour chaque colonne
		printf "${PID_COLOR}%-6s${NC} | ${OWNER_COLOR}%-14s${NC}  | ${PROCESS_COLOR}%-25s${NC} | ${MEMORY_COLOR}%-10s${NC}\n" "PID" "Propriétaire" "Nom du processus" "Mémoire utilisée"
		printf "${NC}-----------------------------------------------------------------------${NC}\n"

		# Obtient la liste de tous les processus avec leur propriétaire et leur utilisation de mémoire
		ps -eo pid,user,comm,%mem --sort=-%mem | grep "$filter" | awk '{ printf("'$PID_COLOR'%-6s'$NC' | '$OWNER_COLOR'%-14s'$NC' | '$PROCESS_COLOR'%-25s'$NC' | '$MEMORY_COLOR'%-10s'$NC' \n", $1, $2, $3, $4) }'

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