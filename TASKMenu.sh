#!/bin/bash

clear

while true; do
    echo "Entrez le chiffre du service dont vous avez besoin :"
    cat << FIN
---Menu------------------------
1) Lister les sous fichiers/répertoires du répertoire courant
2) Chercher un fichier
3) Vérifier le type (fichier ou répertoire)
4) Copier un fichier
5) Déplacer un fichier
6) Supprimer un fichier
7) Modifier le nom d'un fichier
8) Afficher tous les utilisateurs standards du système (avec awk)
9) Désactiver SELinux donc le mettre en mode permissive (avec sed)
10) Activer SELinux donc le mettre en mode enforcing (avec sed)
11) Afficher les 5 processus qui utilisent le plus de mémoire RAM en pourcentage
12) Quitter
FIN
    read -p "Faire un choix :" CHOIX

    case $CHOIX in
        1) ls ;;
        2)
            read -p "Entrez le nom du fichier à chercher : " trouve
            find . -name "$trouve" ;;
        3)
            read -p "Entrez le nom : " NAME
            if [[ -d $NAME ]]; then
                echo "$NAME est un répertoire."
            elif [[ -f $NAME ]]; then 
                echo "$NAME est un fichier."
            else
                echo "$NAME n'est ni un fichier ni un répertoire."
            fi ;;
        4)
            read -p "Veuillez saisir le chemin valide du fichier ou répertoire à copier : " path
            if [ -e "$path" ]; then
                cp -R "$path" || echo "Erreur lors de la copie de $path."
            else
                echo "Le chemin spécifié n'existe pas."
            fi ;;
        5)
            read -p "Entrez le nom du fichier à déplacer : " fichier
            read -p "Entrez le répertoire de destination : " destination
            if [ -e "$fichier" ] && [ -d "$destination" ]; then
                mv "$fichier" "$destination" || echo "Erreur lors du déplacement de $fichier vers $destination."
                echo "$fichier a été déplacé vers $destination avec succès."
            else
                echo "Le fichier spécifié n'existe pas ou la destination n'est pas un répertoire valide."
            fi ;;
        6)
            read -p "Entrez le nom du fichier à supprimer (Valide que pour fichier pas de répertoire): " fichier
            if [ -f "$fichier" ]; then
                rm "$fichier" || echo "Erreur lors de la suppression de $fichier."
                echo "$fichier a été supprimé."
            else
                echo "Le fichier spécifié n'existe pas ou n'est pas un fichier."
            fi ;;
        7)
            read -p "Entrez l'ancien nom du fichier : " ancien_nom
            read -p "Entrez le nouveau nom du fichier : " nouveau_nom
            if [ -e "$ancien_nom" ]; then
                mv "$ancien_nom" "$nouveau_nom" || echo "Erreur lors du renommage de $ancien_nom en $nouveau_nom."
                echo "Le fichier/répertoire a été renommé avec succès."
            else
                echo "Le fichier/répertoire spécifié n'existe pas."
            fi ;;
        8)
            awk -F: '$3>=1000 && $1!="nobody" {print $1}' /etc/passwd ;;
        9)
            sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config && echo "SELinux a été mis en mode permissive avec succès." ;;
        10)
            sed -i 's/SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config && echo "SELinux a été mis en mode enforcing avec succès." ;;
        11)
            ps -eo pmem,pcpu,pid,ppid,user,args | sort -k 1 -nr | head -5 ;;
        12)
            sleep 3
            echo "Au revoir!"
            exit 0 ;;
        *) echo "Choix invalide." ;;
    esac
done
