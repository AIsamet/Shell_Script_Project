function show_process_explorer_options() {
	clear
	echo "============================"
	echo "  PROCESS EXPLORER"
	echo "============================"
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
	sortie="Tous les processus présents sur le système : $(ps -ef)"
	echo -e $sortie
	echo ""
	write_logs $sortie
}

# 2. Identifier uniquement les processus actifs et indiquer leur propriétaire
function show_active_processes() {
	sortie="Tous les processus actifs sur le système : $(ps -ef | grep -v 'grep')"
	echo -e $sortie
	echo ""
	write_logs $sortie
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
	read -p "Votre choix : " choix
	case $choix in
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
}

show_process_explorer_options
selection