#!/bin/bash
clear
echo -e "\033[1;32mAPAKAH ANDA INGIN MENGHAPUS SSH MANAGER?\033[1;33m"
read -p "Apakah Anda ingin menghapus? [y/n] " resp
if [[ "$resp" = y || "$resp" = Y ]];then
    apt-get purge screen -y > /dev/null 2>&1
    apt-get purge nmap -y > /dev/null 2>&1
    apt-get purge figlet -y > /dev/null 2>&1
    apt-get purge squid -y > /dev/null 2>&1
    apt-get purge squid3 -y > /dev/null 2>&1
    apt-get purge dropbear -y > /dev/null 2>&1
    apt-get purge apache2 -y > /dev/null 2>&1
    rm /bin/criarusuario /bin/expcleaner /bin/sshlimiter /bin/addhost /bin/listar /bin/sshmonitor /bin/ajuda /bin/menu /bin/OpenVPN /bin/userbackup /bin/tcpspeed /bin/badvpn /bin/otimizar /bin/speedtest /bin/trafego /bin/banner /bin/limit /bin/limite /bin/senharoot /bin/reiniciarservicos /bin/reiniciarsistema /bin/attscript /bin/criarteste /bin/socks  /bin/DropBear /bin/alterarlimite /bin/alterarsenha /bin/remover /bin/detalhes /bin/mudardata /bin/botssh /bin/infousers /bin/droplimiter /bin/conexao /bin/versao > /dev/null 2>&1
    rm -rf /etc/SSHPlus > /dev/null 2>&1
    clear
    echo -e "\033[1;36mTerima kasih telah menggunakan SSH MANAGER\033[1;33m"
    sleep 2
    cat /dev/null > ~/.bash_history && history -c && exit 0
else
    echo -e "\033[1;32mOk kembali ke menu\033[1;33m"
    sleep 3
    menu
fi
