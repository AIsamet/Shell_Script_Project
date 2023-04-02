# Mode d'emploi

## Dépendances
**Tree :**

    sudo apt-get update

    sudo apt-get install tree

## Exécution
Décompressez l'archive... 
Depuis le répertoire contenant les scripts, copiez les fichiers dans **/usr/local/bin** :

    sudo cp -r . /usr/local/bin

Puis exécutez depuis n'importe où la commande suivante :

    menu.sh

**Ou**
Depuis le répertoire contenant les scripts, exécutez la commande suivante :

    ./menu.sh

## Informations complémentaires

*Se référer aux informations présentes dans le fichier **"Système_projet_bash.pdf"** section **"Comment exécuter le script ?"***

## Troubleshooting 

En cas d'erreur d'exécution, tapez la commande suivante :

    sed -i 's/\r//' menu.sh file_explorer.sh process_explorer.sh services_explorer.sh