#!/bin/bash


function show_services_explorer_options() {
	clear
	echo "============================"
	echo "  SERVICES EXPLORER"
	echo "============================"
	echo "1. Identifier les services disponibles/installés sur le système"
	echo "2. Identifier les services actifs sur le système"
	echo "3. Identifier le statut d’un service dont le nom contient une chaine de caractères (définie en paramètre)"
	echo "4. *A définir*"
	echo "R. Retour"
	echo "Q. Quitter"
}

function write_logs() {
	echo -e "--------------------------------------------------------------------------------------------------------------------------" >> logs.txt
	echo -e "$*" "						$(date)" >> logs.txt 
	echo -e "--------------------------------------------------------------------------------------------------------------------------" >> logs.txt
}

# 1. Identifier les services disponibles/installés sur le système
function show_all_services() {
	sortie="Tous les services disponibles/installés sur le système : $(systemctl list-unit-files | grep enabled)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

# 2. Identifier les services actifs sur le système
function show_active_services() {
	sortie="Tous les services actifs sur le système : $(systemctl list-units --type=service --state=active)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

# 3. Identifier le statut d’un service dont le nom contient une chaine de caractères (définie en paramètre)
function show_services_by_name() {
	read -p "Entrez le nom du service : " service_name
	sortie="Tous les services dont le nom contient une chaine de caractères (définie en paramètre) : $(systemctl status $service_name)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

function selection() {
	read -p "Votre choix : " choix
	case $choix in
		1) show_all_services ;;
		2) show_active_services ;;
		3) show_services_by_name ;;
		4) *A définir* ;;
		r|R) bash menu.sh 
		break ;;
		q|Q) exit 0;;
		*) echo "Erreur : choix invalide" 
		selection
		break;;
	esac
}

show_services_explorer_options
selection