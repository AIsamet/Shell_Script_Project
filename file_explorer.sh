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
	echo -e "Q. Quitter\n"
}

function write_logs() {
	echo -e "--------------------------------------------------------------------------------------------------------------------------" >> logs.txt
	echo -e "$*" "						$(date)" >> logs.txt 
	echo -e "--------------------------------------------------------------------------------------------------------------------------" >> logs.txt
}

# 1. Afficher le répertoire courant
function show_current_dir() {
	sortie="Répertoire courant : $(pwd)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

# 2. Afficher la date et l'heure du système
function show_date_time() {
	sortie="Date et heure du système : $(date)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

# 3. Afficher le nombre de fichiers et leur taille dans le répertoire courant
function show_files_info() {
	sortie="Nombre de fichiers dans le répertoire courant : $(ls -1 | wc -l)"
	sortie="${sortie} \nTaille totale des fichiers dans le répertoire courant : $(du -sh . | cut -f1)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

# 4. Afficher le nombre de sous-répertoires dans le répertoire courant
function show_subdirs_count() {
	echo "Nombre de sous-répertoires dans le répertoire courant : $(find . -maxdepth 1 -type d | wc -l)"
	echo ""
}

# 5. Afficher l'arborescence du répertoire courant -> à modifier
function show_directory_tree() {
	echo "Arborescence du répertoire courant :"
	echo ""
	tree .
	echo ""
}

# 6. Afficher le poids de chaque sous-répertoire dans le répertoire courant
function show_subdirs_size() {
	echo "Poids de chaque sous-répertoire dans le répertoire courant :"
	echo ""
	du -sh */
	echo ""
}

# 7. Changer de répertoire courant
function change_directory() {
	echo -e -n "${GREEN}Entrez le chemin absolu ou relatif du répertoire : ${NC}"
	read directory
	cd "$directory" || echo "Erreur : répertoire inexistant" >&2
}

# 8. Rechercher les fichiers plus récents qu'une date dans le répertoire courant
function find_files_newer_than() {
	echo -e -n "${GREEN}Entrez la date (format AAAA-MM-JJ HH:MM:SS) : ${NC}"
	read date
	find . -maxdepth 1 -type f -newermt "$date"
}

# 9. Rechercher les fichiers plus récents qu'une date dans tous les sous-répertoires
function find_files_newer_than_recursive() {
	echo -e -n "${GREEN}Entrez la date (format AAAA-MM-JJ HH:MM:SS) : ${NC}"
	read date
	find . -type f -newermt "$date"
}

# 10. Rechercher les fichiers plus anciens qu'une date dans le répertoire courant
function find_files_older_than() {
	echo -e -n "${GREEN}Entrez la date (format AAAA-MM-JJ HH:MM:SS) : ${NC}"
	read date
	find . -maxdepth 1 -type f ! -newermt "$date"
}

# 11. Rechercher les fichiers plus anciens qu'une date dans tous les sous-répertoires
function find_files_older_than_recursive() {
	echo -e -n "${GREEN}Entrez la date (format AAAA-MM-JJ HH:MM:SS) : ${NC}"
	read date
	find . -type f ! -newermt "$date"
}

# 12. Rechercher les fichiers de poids supérieur à une valeur dans le répertoire courant
function find_files_larger_than() {
	echo -e -n "${GREEN}Entrez la taille (format X[kMG]) : ${NC}"
	read size
	find . -maxdepth 1 -type f -size +$size
}

# 13. Rechercher les fichiers de poids supérieur à une valeur dans tous les sous-répertoires
function find_files_larger_than_recursive() {
	echo -e -n "${GREEN}Entrez la taille (format X[kMG]) : ${NC}"
	read size
	find . -type f -size +$size
}

# 14. Rechercher les fichiers de poids inférieur à une valeur dans le répertoire courant
function find_files_smaller_than() {
	echo -e -n "${GREEN}Entrez la taille (format X[kMG]) : ${NC}"
	read size
	find . -maxdepth 1 -type f -size -$size
}

# 15. Rechercher les fichiers de poids inférieur à une valeur dans tous les sous-répertoires
function find_files_smaller_than_recursive() {
	echo -e -n "${GREEN}Entrez la taille (format X[kMG]) : ${NC}"
	read size
	find . -type f -size -$size
}
# 16. Rechercher tous les fichiers d'une extension donnée dans le répertoire courant
function find_files_with_extension() {
	echo -e -n "${GREEN}Entrez l'extension de fichier recherchée : ${NC}"
	read extension
	find . -maxdepth 1 -type f -name "*.$extension"
}

# 17. Rechercher tous les fichiers d'une extension donnée dans tous les sous-répertoires
function find_files_with_extension_recursive() {
	echo -e -n "${GREEN}Entrez l'extension de fichier recherchée : ${NC}"
	read extension
	find . -type f -name "*.$extension"
}

# 18. Rechercher tous les fichiers dont le nom contient une chaine de caractère dans tous les sous-répertoires
function find_files_with_string() {
	echo -e -n "${GREEN}Entrez la chaine de caractères recherchée : ${NC}"
	read string
	find . -type f -name "$string"
}

# Function selection
function selection() {
	while true; do 
		echo -e -n "${GREEN}Entrez votre choix : ${NC}"
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