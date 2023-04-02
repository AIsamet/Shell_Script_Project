#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' 

function show_file_explorer_options() {
	clear
	echo -n "
  ___ ___ _    ___   _____  _____ _    ___  ___ ___ ___ 
 | __|_ _| |  | __| | __\ \/ / _ \ |  / _ \| _ \ __| _ \ 
 | _| | || |__| _|  | _| >  <|  _/ |_| (_) |   / _||   /
 |_| |___|____|___| |___/_/\_\_| |____\___/|_|_\___|_|_\ 
                                                        
"
	echo "1. Afficher le répertoire courant"
	echo "2. Afficher la date et l'heure du système"
	echo "3. Afficher le nombre de fichiers et leur taille dans le répertoire courant"
	echo "4. Afficher le nombre de sous-répertoires dans le répertoire courant"
	echo "5. Afficher l'arborescence du répertoire courant"
	echo "6. Afficher le poids de chaque sous-répertoire dans le répertoire courant"
	echo "7. Changer de répertoire courant"
	echo "8. Rechercher les fichiers plus récents qu'une date dans le répertoire courant"
	echo "9. Rechercher les fichiers plus récents qu'une date dans tous les sous-répertoires"
	echo "10. Rechercher les fichiers plus anciens qu'une date dans le répertoire courant"
	echo "11. Rechercher les fichiers plus anciens qu'une date dans tous les sous-répertoires"
	echo "12. Rechercher les fichiers de poids supérieur à une valeur dans le répertoire courant"
	echo "13. Rechercher les fichiers de poids supérieur à une valeur dans tous les sous-répertoires"
	echo "14. Rechercher les fichiers de poids inférieur à une valeur dans le répertoire courant"
	echo "15. Rechercher les fichiers de poids inférieur à une valeur dans tous les sous-répertoires"
	echo "16. Rechercher tous les fichiers d'une extension donnée dans le répertoire courant"
	echo "17. Rechercher tous les fichiers d'une extension donnée dans tous les sous-répertoires"
	echo "18. Rechercher tous les fichiers dont le nom contient une chaine de caractère dans tous les sous-répertoires"
	# + Chaque résultat de sortie doit être sauvegardé dans un fichier (résultats précédent doivent pas être supprimés + trié par date)
	echo -e "19. *A définir*\n"
	echo "R. Retour"
	echo -e "Q. Quitter"
}

function write_logs() {
    LOGS_DIR="/home/$(whoami)/script_logs"
    LOGS_FILE="$LOGS_DIR/logs.txt"

	 if [ ! -d "$LOGS_DIR" ]; then
        mkdir -p "$LOGS_DIR"
    fi

    echo -e "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" >> "$LOGS_FILE"
    echo -e "$(date) |" " $*" >> "$LOGS_FILE"
    echo -e "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" >> "$LOGS_FILE"
}

# a. Afficher le répertoire courant
function show_current_dir() {
	sortie="Répertoire courant : $(pwd)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

# b. Afficher la date et l'heure du système
function show_date_time() {
	sortie="Date et heure du système : $(date)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

# c. Afficher le nombre de fichiers et leur taille dans le répertoire courant
function show_files_info() {
	sortie="Nombre de fichiers dans le répertoire courant : $(ls -1 | wc -l)"
	sortie="${sortie} \nTaille totale des fichiers dans le répertoire courant : $(du -sh . | cut -f1)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

# d. Afficher le nombre de sous-répertoires dans le répertoire courant
function show_subdirs_count() {
	sortie="Nombre de sous-répertoires dans le répertoire courant : $(find . -maxdepth 1 -type d | wc -l)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

# e. Afficher l'arborescence du répertoire courant
function show_directory_tree() {
	echo -e -n "${GREEN}Entrez la profondeur de recherche souhaitée : ${NC}"
	read profondeur
	sortie="\nArborescence du répertoire courant ('$(pwd)') avec la profondeur ${profondeur} :"
	echo -e $sortie
	sortie="${sortie}\n$(tree . -L $profondeur)"
	write_logs $sortie
	tree . -L $profondeur
	echo ""
}

# f. Afficher le poids de chaque sous-répertoire dans le répertoire courant
function show_subdirs_size() {
	sortie="Poids de chaque sous-répertoire dans le répertoire courant :"
	echo -e $sortie
	sortie="${sortie} \n$(du -sh ./* | sort -h)"
	du -sh */
	write_logs $sortie
	echo ""
}

# g. Changer de répertoire courant
function change_directory() {
	sortie="${GREEN}Entrez le chemin absolu ou relatif du répertoire : ${NC}"
	echo -e -n "${GREEN}Entrez le chemin absolu ou relatif du répertoire : ${NC}"
	read directory
	sortie="${sortie} \nChangement de répertoire courant : $(pwd) -> ${directory}"
	write_logs $sortie
	cd "$directory" || echo "Erreur : répertoire inexistant" >&2
}

# h. Rechercher les fichiers plus récents qu'une date dans le répertoire courant
function find_files_newer_than() {
	sortie="${GREEN}Entrez la date (format AAAA-MM-JJ HH:MM:SS) : ${NC}"
	echo -e -n "${GREEN}Entrez la date (format AAAA-MM-JJ HH:MM:SS) : ${NC}"
	read date
	sortie="${sortie} \nRecherche des fichiers plus récents que ${date} dans le répertoire courant :"
	find . -maxdepth 1 -type f -newermt "$date"
	sortie="${sortie} \n$(find . -maxdepth 1 -type f -newermt "$date")"
	write_logs $sortie
}

# i. Rechercher les fichiers plus récents qu'une date dans tous les sous-répertoires
function find_files_newer_than_recursive() {
	sortie="${GREEN}Entrez la date (format AAAA-MM-JJ HH:MM:SS) : ${NC}"
	echo -e -n "${GREEN}Entrez la date (format AAAA-MM-JJ HH:MM:SS) : ${NC}"
	read date
	sortie="${sortie} \nRecherche des fichiers plus récents que ${date} dans tous les sous-répertoires :"
	find . -type f -newermt "$date"
	sortie="${sortie} \n$(find . -type f -newermt "$date")"
	write_logs $sortie
}

# j. Rechercher les fichiers plus anciens qu'une date dans le répertoire courant
function find_files_older_than() {
	sortie="${GREEN}Entrez la date (format AAAA-MM-JJ HH:MM:SS) : ${NC}"
	echo -e -n "${GREEN}Entrez la date (format AAAA-MM-JJ HH:MM:SS) : ${NC}"
	read date
	sortie="${sortie} \nRecherche des fichiers plus anciens que ${date} dans le répertoire courant :"
	find . -maxdepth 1 -type f ! -newermt "$date"
	sortie="${sortie} \n$(find . -maxdepth 1 -type f ! -newermt "$date")"
	write_logs $sortie
}

# k. Rechercher les fichiers plus anciens qu'une date dans tous les sous-répertoires
function find_files_older_than_recursive() {
	sortie="${GREEN}Entrez la date (format AAAA-MM-JJ HH:MM:SS) : ${NC}"
	echo -e -n "${GREEN}Entrez la date (format AAAA-MM-JJ HH:MM:SS) : ${NC}"
	read date
	sortie="${sortie} \nRecherche des fichiers plus anciens que ${date} dans tous les sous-répertoires :"
	find . -type f ! -newermt "$date"
	sortie="${sortie} \n$(find . -type f ! -newermt "$date")"
	write_logs $sortie
}

# l. Rechercher les fichiers de poids supérieur à une valeur dans le répertoire courant
function find_files_larger_than() {
	sortie="${GREEN}Entrez l'unité (k : Ko | M : Mo | G : Go) : ${NC}"
	echo -e -n "${GREEN}Entrez l'unité (k : Ko | M : Mo | G : Go) : ${NC}"
	read unit
	sortie="${sortie} \nEntrez la taille (unité ${unit}) :"
	echo -e -n "${GREEN}Entrez la taille (unité ${unit}) : ${NC}"
	read size
	sortie="${sortie} \nRecherche des fichiers de poids supérieur à ${size}${unit} dans le répertoire courant :"
	find . -maxdepth 1 -type f -size +${size}${unit}
	sortie="${sortie} \n$(find . -maxdepth 1 -type f -size +${size}${unit})"
	write_logs $sortie
}

# m. Rechercher les fichiers de poids supérieur à une valeur dans tous les sous-répertoires
function find_files_larger_than_recursive() {
	sortie="${GREEN}Entrez l'unité (k : Ko | M : Mo | G : Go) : ${NC}"
	echo -e -n "${GREEN}Entrez l'unité (k : Ko | M : Mo | G : Go) : ${NC}"
	read unit
	sortie="${sortie} \nEntrez la taille (unité ${unit}) :"
	echo -e -n "${GREEN}Entrez la taille (unité {unit}) : ${NC}"
	read size
	sortie="${sortie} \nRecherche des fichiers de poids supérieur à ${size}${unit} dans tous les sous-répertoires :"
	find . -type f -size +${size}${unit}
	sortie="${sortie} \n$(find . -type f -size +${size}${unit})"
	write_logs $sortie
}

# n. Rechercher les fichiers de poids inférieur à une valeur dans le répertoire courant
function find_files_smaller_than() {
	sortie="${GREEN}Entrez l'unité (k : Ko | M : Mo | G : Go) : ${NC}"
	echo -e -n "${GREEN}Entrez l'unité (k : Ko | M : Mo | G : Go) : ${NC}"
	read unit
	sortie="${sortie} \nEntrez la taille (unité ${unit}) :"
	echo -e -n "${GREEN}Entrez la taille (unité {unit}) : ${NC}"
	read size
	sortie="${sortie} \nRecherche des fichiers de poids inférieur à ${size}${unit} dans le répertoire courant :"
	find . -maxdepth 1 -type f -size -${size}${unit}
	sortie="${sortie} \n$(find . -maxdepth 1 -type f -size -${size}${unit})"
	write_logs $sortie
}

# o. Rechercher les fichiers de poids inférieur à une valeur dans tous les sous-répertoires
function find_files_smaller_than_recursive() {
	sortie="${GREEN}Entrez l'unité (k : Ko | M : Mo | G : Go) : ${NC}"
	echo -e -n "${GREEN}Entrez l'unité (k : Ko | M : Mo | G : Go) : ${NC}"
	read unit
	sortie="${sortie} \nEntrez la taille (unité ${unit}) :"
	echo -e -n "${GREEN}Entrez la taille (unité {unit}) : ${NC}"
	read size
	sortie="${sortie} \nRecherche des fichiers de poids inférieur à ${size}${unit} dans tous les sous-répertoires :"
	find . -type f -size -${size}${unit}
	sortie="${sortie} \n$(find . -type f -size -${size}${unit})"
	write_logs $sortie
}
# p. Rechercher tous les fichiers d'une extension donnée dans le répertoire courant
function find_files_with_extension() {
	sortie="${GREEN}Entrez l'extension de fichier recherchée : ${NC}"
	echo -e -n "${GREEN}Entrez l'extension de fichier recherchée : ${NC}"
	read extension
	sortie="${sortie} \nRecherche des fichiers d'extension ${extension} dans le répertoire courant :"
	find . -maxdepth 1 -type f -name "*.$extension"
	sortie="${sortie} \n$(find . -maxdepth 1 -type f -name "*.$extension")"
	write_logs $sortie
}

# q. Rechercher tous les fichiers d'une extension donnée dans tous les sous-répertoires
function find_files_with_extension_recursive() {
	sortie="${GREEN}Entrez l'extension de fichier recherchée : ${NC}"
	echo -e -n "${GREEN}Entrez l'extension de fichier recherchée : ${NC}"
	read extension
	sortie="${sortie} \nRecherche des fichiers d'extension ${extension} dans tous les sous-répertoires :"
	find . -type f -name "*.$extension"
	sortie="${sortie} \n$(find . -type f -name "*.$extension")"
	write_logs $sortie
}

# r. Rechercher tous les fichiers dont le nom contient une chaine de caractère dans tous les sous-répertoires
function find_files_with_string() {
	sortie="${GREEN}Entrez la chaine de caractère recherchée : ${NC}"
	echo -e -n "${GREEN}Entrez la chaine de caractère recherchée : ${NC}"
	read string
	sortie="${sortie} \nRecherche des fichiers dont le nom contient ${string} dans tous les sous-répertoires :"
	find . -type f -name "*$string*"
	sortie="${sortie} \n$(find . -type f -name "*$string*")"
	write_logs $sortie
}

# Function selection
function selection() {
	while true; do 
		echo -e -n "\n${GREEN}Entrez votre choix : ${NC}"
		read choice
		case $choice in
			1) show_current_dir;;
			2) show_date_time ;;
			3) show_files_info ;;
			4) show_subdirs_count ;;
			5) show_directory_tree ;;
			6) show_subdirs_size ;;
			7) change_directory ;;
			8) find_files_newer_than ;;
			9) find_files_newer_than_recursive ;;
			10) find_files_older_than ;;
			11) find_files_older_than_recursive ;;
			12) find_files_larger_than ;;
			13) find_files_larger_than_recursive ;;
			14) find_files_smaller_than ;;
			15) find_files_smaller_than_recursive ;;
			16) find_files_with_extension ;;
			17) find_files_with_extension_recursive ;;
			18) find_files_with_string ;;
			19) echo "A définir" ;;
			r|R) bash menu.sh 
			break ;;
			q|Q) exit 0;;
			*) echo "Erreur : choix invalide" 
			selection
			break;;
		esac
	done
}

show_file_explorer_options
selection