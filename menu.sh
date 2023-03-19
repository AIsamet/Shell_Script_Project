# Fonction pour afficher le menu principal
function show_menu() {
	clear
	echo "============================"
	echo "  MENU PRINCIPAL"
	echo "============================"
	echo "1. File explorer"
	echo "2. Process epxlorer"
	echo "3. Services explorer"
	echo "Q. Quitter"
}

show_menu

while true; do
	read -p "Choisissez une option : " choice
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
