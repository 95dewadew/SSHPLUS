#!/bin/bash
if [[ -e /usr/lib/licence ]]; then
ram1=$(free -h | grep -i mem | awk {'print $2'})
ram2=$(free -h | grep -i mem | awk {'print $4'})
ram3=$(free -h | grep -i mem | awk {'print $3'})
uso=$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')
system=$(cat /etc/issue.net)
fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
[[ ! -d /etc/SSHPlus ]] && rm -rf /bin/menu
${comando[0]} > /dev/null 2>&1
${comando[1]} > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
echo -ne "\033[1;33mTUNGGU \033[1;37m- \033[1;33m["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "\033[1;33mTUNGGU \033[1;37m- \033[1;33m["
done
echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}

verif_ptrs () {
porta=$1
PT=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
for pton in `echo -e "$PT" | cut -d: -f2 | cut -d' ' -f1 | uniq`; do
    svcs=$(echo -e "$PT" | grep -w "$pton" | awk '{print $1}' | uniq)
    [[ "$porta" = "$pton" ]] && {
    	echo -e "\n\033[1;31mPORT \033[1;33m$porta \033[1;31mDIGUNAKAN OLEH \033[1;37m$svcs\033[0m"
    	sleep 3
    	fun_conexao
    }
done
}

inst_sqd (){
if netstat -nltp|grep 'squid' 1>/dev/null 2>/dev/null;then
	echo -e "\E[41;1;37m            HAPUS SQUID PROXY              \E[0m"
	echo ""
	echo -ne "\033[1;32mBENAR-BENAR INGIN MENGHAPUS SQUID \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read resp
	if [[ "$resp" = 's' ]]; then
		echo -e "\n\033[1;32mMENGHAPUS PROXY SQUID !\033[0m"
		echo ""
		rem_sqd () 
		{
		if [[ -d "/etc/squid/" ]]; then
			apt-get remove squid -y
			apt-get purge squid -y
			rm -rf /etc/squid
		fi
		if [[ -d "/etc/squid3/" ]]; then
			apt-get remove squid3 -y
			apt-get purge squid3 -y
			rm -rf /etc/squid3
		fi
	    }
	    fun_bar 'rem_sqd'
		echo -e "\n\033[1;32mSQUID DIHAPUS DENGAN SUKSES !\033[0m"
		sleep 3.5s
		clear
		fun_conexao
	else
		echo -e "\n\033[1;31mKembali...\033[0m"
		sleep 3
		clear
		fun_conexao
	fi
else
clear
echo -e "\E[44;1;37m              INSTAL SQUID                \E[0m"
echo ""
IP=$(wget -qO- ipv4.icanhazip.com)
echo -ne "\033[1;32mUNTUK LANJUTKAN KONFIRMASI IP ANDA: \033[1;37m"; read -e -i $IP ipdovps
if [[ -z "$ipdovps" ]];then
echo -e "\n\033[1;31mIP tidak valid\033[1;32m"
echo ""
read -p "Digite seu IP: " IP
fi
echo -e "\n\033[1;33mPORT YANG SAYA INGIN GUNAKAN SQUID \033[1;31m?"
echo -e "\n\033[1;33m[\033[1;31m!\033[1;33m] \033[1;32mPORT DALAM URUTAN\033[1;33mEX: \033[1;37m80 8080 8799"
echo ""
echo -ne "\033[1;32mINFORMASI PORT\033[1;37m: "; read portass
if [[ -z "$portass" ]]; then
	echo -e "\n\033[1;31mPort tidak valid!"
	sleep 3
	fun_conexao
fi
for porta in $(echo -e $portass); do
	verif_ptrs $porta
done
echo -e "\n\033[1;32mMENGINSTAL PROXY SQUID\033[0m"
echo ""
fun_bar 'apt-get update -y' 'apt-get install squid3 -y'
sleep 1
if [[ -d "/etc/squid/" ]]; then
var_sqd="/etc/squid/squid.conf"
var_pay="/etc/squid/payload.txt"
elif [[ -d "/etc/squid3/" ]]; then
var_sqd="/etc/squid3/squid.conf"
var_pay="/etc/squid3/payload.txt"
fi
echo ".claro.com.br/
.claro.com.sv/
.facebook.net/
.netclaro.com.br/
.speedtest.net/
.tim.com.br/
.vivo.com.br/
.oi.com.br/" > $var_pay
echo "#acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst $ipdovps-$ipdovps/255.255.255.255
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all

 
#Port" > $var_sqd
for Pts in $(echo -e $portass); do
echo -e "http_port $Pts" >> $var_sqd
[[ -f "/usr/sbin/ufw" ]] && ufw allow $Pts/tcp
done
echo -e "
#Name squid
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname SSH" >> $var_sqd
sqd_conf () {
if [[ -d "/etc/squid/" ]]; then
squid -k reconfigure
service ssh restart
service squid restart
elif [[ -d "/etc/squid3/" ]]; then
squid3 -k reconfigure
service ssh restart
service squid3 restart
fi
}
echo -e "\n\033[1;32mMENGONFIGURASI SQUID PROXY\033[0m"
echo ""
fun_bar 'sqd_conf'
echo -e "\n\033[1;32mSQUID SUKSES DIINSTAL!\033[0m"
sleep 3.5s
fun_conexao
fi
}

addpt_sqd () {
	echo -e "\E[44;1;37m         TAMBAHKAN PORT SQUID          \E[0m"
	echo -e "\n\033[1;33mPORT SQUID: \033[1;32m$sqdp\n"
	if [[ -f "/etc/squid/squid.conf" ]]; then
		var_sqd="/etc/squid/squid.conf"
	elif [[ -f "/etc/squid3/squid.conf" ]]; then
		var_sqd="/etc/squid3/squid.conf"
	else
		echo -e "\n\033[1;31mSQUID TIDAK DIINSTAL!\033[0m"
		echo -e "\n\033[1;31mKembali...\033[0m"
		sleep 2
		clear
		fun_squid
	fi
	echo -ne "\033[1;32mPORT YANG ANDA INGINKAN \033[1;33m?\033[1;37m "; read pt
	if [[ -z "$pt" ]]; then
		echo -e "\n\033[1;31mPort tidak valid!"
		sleep 3
		clear
		fun_conexao		
	fi
	verif_ptrs $pt
	echo -e "\n\033[1;32mMENAMBAH PORT SQUID!"
	echo ""
	sed -i "s/#Portas/#Portas\nhttp_port $pt/g" $var_sqd
	fun_bar 'sleep 2'
	echo -e "\n\033[1;32mKEMBALIKAN Squid!"
	echo ""
	fun_bar 'service squid restart' 'service squid3 restart'
	echo -e "\n\033[1;32mPORT SUKSES DITAMBAH!"
	sleep 3
	clear
	fun_squid
}

rempt_sqd () {
	echo -e "\E[41;1;37m        HAPUS PORT SQUID        \E[0m"
	echo -e "\n\033[1;33mPORT SQUID: \033[1;32m$sqdp\n"
	if [[ -f "/etc/squid/squid.conf" ]]; then
		var_sqd="/etc/squid/squid.conf"
	elif [[ -f "/etc/squid3/squid.conf" ]]; then
		var_sqd="/etc/squid3/squid.conf"
	else
		echo -e "\n\033[1;31mSQUID TIDAK DIINSTAL!\033[0m"
		echo -e "\n\033[1;31mKembali...\033[0m"
		sleep 2
		clear
		fun_squid
	fi
	echo -ne "\033[1;32mPORT YANG INGIN DI HAPUS \033[1;33m?\033[1;37m "; read pt
	if [[ -z "$pt" ]]; then
		echo -e "\n\033[1;31mPort tidak valid!"
		sleep 2
		clear
		fun_conexao
	fi
	if grep -E "$pt" $var_sqd > /dev/null 2>&1; then
		echo -e "\n\033[1;32mMENGHAPUS PORT SQUID!"
		echo ""
		sed -i "/http_port $pt/d" $var_sqd
		fun_bar 'sleep 3'
		echo -e "\n\033[1;32mKEMBALIKAN Squid!"
		echo ""
		fun_bar 'service squid restart' 'service squid3 restart'
		echo -e "\n\033[1;32mPORT BERHASIL DIHAPUS!"
		sleep 3.5s
		clear
		fun_squid
	else
		echo -e "\n\033[1;31mPORT \033[1;32m$pt \033[1;31mTIDAK DITEMUKAN!"
		sleep 3.5s
		clear
		fun_squid
	fi
}

fun_squid () {
[[ "$(netstat -nplt |grep -c 'squid')" = "0" ]] && inst_sqd
echo -e "\E[44;1;37m          KELOLA SQUID PROXY           \E[0m"
[[ "$(netstat -nplt |grep -c 'squid')" != "0" ]] && {
sqdp=$(netstat -nplt |grep 'squid' | awk -F ":" {'print $4'} | xargs)
    echo -e "\n\033[1;33mPORT\033[1;37m: \033[1;32m$sqdp"
    VarSqdOn="REMOVER SQUID PROXY"
} || {
    VarSqdOn="INSTALAR SQUID PROXY"
}
echo -e "\n\033[1;31m[\033[1;36m1\033[1;31m] \033[1;37m• \033[1;33m$VarSqdOn \033[1;31m
[\033[1;36m2\033[1;31m] \033[1;37m• \033[1;33mTAMBAH PORT \033[1;31m
[\033[1;36m3\033[1;31m] \033[1;37m• \033[1;33mHAPUS PORT\033[1;31m
[\033[1;36m0\033[1;31m] \033[1;37m• \033[1;33mKEMBALI\033[0m"
echo ""
echo -ne "\033[1;32mAPA YANG INGIN KAMU LAKUKAN \033[1;33m?\033[1;31m?\033[1;37m "; read x
clear
case $x in
	1|01)
	inst_sqd
	;;
	2|02)
	addpt_sqd
	;;
	3|03)
	rempt_sqd
	;;
	0|00)
	echo -e "\033[1;31mKembali...\033[0m"
	sleep 1
	fun_conexao
	;;
	*)
	echo -e "\033[1;31mOpsi Tidak Valid...\033[0m"
	sleep 2
	fun_conexao
	;;
	esac
}

fun_drop () {
	if netstat -nltp|grep 'dropbear' 1>/dev/null 2>/dev/null;then
		clear
		[[ $(netstat -nltp|grep -c 'dropbear') != '0' ]] && dpbr=$(netstat -nplt |grep 'dropbear' | awk -F ":" {'print $4'} | xargs) || sqdp="\033[1;31mINDISPONIVEL"
        if ps x | grep "limiter"|grep -v grep 1>/dev/null 2>/dev/null; then
        	stats='\033[1;32m◉ '
        else
        	stats='\033[1;31m○ '
        fi
		echo -e "\E[44;1;37m              MENGELOLA DROPBEAR               \E[0m"
		echo -e "\n\033[1;33mPORT\033[1;37m: \033[1;32m$dpbr"
		echo ""
		echo -e "\033[1;31m[\033[1;36m1\033[1;31m] \033[1;37m• \033[1;33mLIMIT DROPBEAR $stats\033[0m"
		echo -e "\033[1;31m[\033[1;36m2\033[1;31m] \033[1;37m• \033[1;33mGANTI PORT DROPBEAR\033[0m"
		echo -e "\033[1;31m[\033[1;36m3\033[1;31m] \033[1;37m• \033[1;33mHAPUS DROPBEAR\033[0m"
		echo -e "\033[1;31m[\033[1;36m0\033[1;31m] \033[1;37m• \033[1;33mKEMBALI\033[0m"
		echo ""
		echo -ne "\033[1;32mAPA YANG INGIN KAMU LAKUKAN \033[1;33m?\033[1;37m "; read resposta
		if [[ "$resposta" = '1' ]]; then
			clear
			if ps x | grep "limiter"|grep -v grep 1>/dev/null 2>/dev/null; then
				echo -e "\033[1;32mMenghentikan limit... \033[0m"
				echo ""
				fun_stplimiter () {
					pidlimiter=$(ps x|grep "limiter"|awk -F "pts" {'print $1'})
					kill -9 $pidlimiter
					screen -wipe
				}
				fun_bar 'fun_stplimiter' 'sleep 2'
				echo -e "\n\033[1;31m LIMIT DI MATIKAN \033[0m"
				sleep 3
				fun_drop
			else
				echo -e "\n\033[1;32mMulai membuat limit... \033[0m"
				echo ""
				fun_bar 'screen -d -m -t limiter droplimiter' 'sleep 3'
				echo -e "\n\033[1;32m  LIMIT AKTIF \033[0m"
				sleep 3
				fun_drop
			fi
		elif [[ "$resposta" = '2' ]]; then
			echo ""
			echo -ne "\033[1;32mPORT YANG ANDA INGINKAN \033[1;33m?\033[1;37m "; read pt
			echo ""
			verif_ptrs $pt
			var1=$(sed -n '6 p' /etc/default/dropbear)
			echo -e "\033[1;32mMENGUBAH PORT DROPBEAR!"
			sed -i "s/$var1/DROPBEAR_PORT=$pt/g" /etc/default/dropbear > /dev/null 2>&1
			echo ""
			fun_bar 'sleep 3'
			echo -e "\n\033[1;32mPENGATURAN DROPBEAR!"
			echo ""
		    fun_bar 'service dropbear restart' 'service ssh restart'
			echo -e "\n\033[1;32mPORT BERHASIL DI RUBAH!"
			sleep 3
			clear
			fun_conexao
		elif [[ "$resposta" = '3' ]]; then
			echo -e "\n\033[1;32mMENGHAPUS DROPBEAR !\033[0m"
			echo ""
			fun_dropunistall () {
				service dropbear stop && /etc/init.d/dropbear stop
				apt-get autoremove dropbear -y
				apt-get remove dropbear -y
				apt-get purge dropbear -y
				rm -rf /etc/default/dropbear
			}
			fun_bar 'fun_dropunistall'
			echo -e "\n\033[1;32mDROPBEAR DIHAPUS SECARA SUKSES !\033[0m"
			sleep 3
			clear
			fun_conexao
		elif [[ "$resposta" = '0' ]]; then
			echo -e "\n\033[1;31mKembali...\033[0m"
			sleep 2
			fun_conexao
		else
			echo -e "\n\033[1;31mOpsi tidak valid...\033[0m"
			sleep 2
			fun_conexao
		fi
	else
		clear
		echo -e "\E[44;1;37m           INSTALL DROPBEAR              \E[0m"
		echo -e "\n\033[1;33mPENGATURAN INSTALL DROPBEAR !\033[0m\n"
		echo -ne "\033[1;32mAPAKAH ANDA INGIN LANJUTKAN? \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read resposta
		if [[ "$resposta" = 's' ]]; then
			echo -e "\n\033[1;33mPORT UNTUK DROPBEAR !\033[0m\n"
			echo -ne "\033[1;32mTULIS PORT \033[1;33m?\033[1;37m "; read porta
			if [[ -z "$porta" ]]; then
				echo -e "\n\033[1;31mPort tidak valid!"
				sleep 3
				clear
				fun_conexao
			fi  
	        verif_ptrs $porta
			echo -e "\n\033[1;32mMENGINSTAL DROPBEAR ! \033[0m"
			echo ""
			fun_instdrop () {
				dpkg --configure -a
				apt-get update -y
				apt-get install dropbear -y
			}
			fun_bar 'fun_instdrop'
			fun_ports () {
				sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear > /dev/null 2>&1
				sed -i "s/DROPBEAR_PORT=22/DROPBEAR_PORT=$porta/g" /etc/default/dropbear > /dev/null 2>&1
				sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 110 -p 777"/g' /etc/default/dropbear > /dev/null 2>&1
			}
			echo ""
			echo -e "\033[1;32mKONFIGURASI PORT DROPBEAR !\033[0m"
			echo ""
			fun_bar 'fun_ports'
			grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
			echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
			grep -v "^PermitTunnel yes" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
			echo "PermitTunnel yes" >> /etc/ssh/sshd_config
			echo ""
			echo -e "\033[1;32mPEMASANGAN BERHASIL !\033[0m"
			echo ""
			fun_ondrop () {
				/etc/init.d/dropbear dropbear start
				service dropbear start
				/etc/init.d/dropbear restart
				service dropbear restart
			}
			fun_bar 'fun_ondrop' 'sleep 3'
			echo -e "\n\033[1;32mINSTALASI SELESAI \033[1;33mPORT: \033[1;37m$porta\033[0m"
			[[ $(grep -c "/bin/false" /etc/shells) = '0' ]] && echo "/bin/false" >> /etc/shells
			sleep 3
			clear
			fun_conexao
		else
			echo""
			echo -e "\033[1;31mKembali...\033[0m"
			sleep 3
			clear
			fun_conexao
		fi
	fi
}

inst_ssl () {	
if netstat -nltp|grep 'stunnel4' 1>/dev/null 2>/dev/null;then
	[[ $(netstat -nltp|grep 'stunnel4'| wc -l) != '0' ]] && sslt=$(netstat -nplt |grep stunnel4 |awk {'print $4'} |awk -F ":" {'print $2'} |xargs) || sslt="\033[1;31mINDISPONIVEL"
    echo -e "\E[44;1;37m              KELOLA STUNNEL SSL               \E[0m"
    echo -e "\n\033[1;33mPORT\033[1;37m: \033[1;32m$sslt"
    echo ""
    echo -e "\033[1;31m[\033[1;36m1\033[1;31m] \033[1;37m• \033[1;33mGANTI PORT SSL TUNNEL\033[0m"
    echo -e "\033[1;31m[\033[1;36m2\033[1;31m] \033[1;37m• \033[1;33mHAPUS SSL TUNNEL\033[0m"
    echo -e "\033[1;31m[\033[1;36m0\033[1;31m] \033[1;37m• \033[1;33mKEMBALI\033[0m"
    echo ""
    echo -ne "\033[1;32mAPA YANG INGIN KAMU LAKUKAN \033[1;33m?\033[1;37m "; read resposta
    echo ""
    if [[ "$resposta" = '1' ]]; then
    echo -ne "\033[1;32mPORT YANG ANDA INGINKAN \033[1;33m?\033[1;37m "; read porta
    echo ""
	if [[ -z "$porta" ]]; then
		echo ""
		echo -e "\033[1;31mPort tidak valid!"
		sleep 3
		clear
		fun_conexao		
	fi
	verif_ptrs $porta
	echo -e "\033[1;32mMENGUBAH  PORT SSL TUNNEL!"
	var2=$(sed -n '9 p' /etc/stunnel/stunnel.conf)
	sed -i "s/$var2/accept = $porta/g" /etc/stunnel/stunnel.conf > /dev/null 2>&1
	echo ""
	fun_bar 'sleep 3'
	echo ""
	echo -e "\033[1;32mMEMULAI ULANG SSL TUNNEL!\n"
	fun_bar 'service stunnel4 restart' '/etc/init.d/stunnel4 restart'
	echo ""
	netstat -nltp|grep 'stunnel4' > /dev/null && echo -e "\033[1;32mPORT SUKSES DI TAMBAHKAN !" || echo -e "\033[1;31mKESALAHAN TAK TERDUGA!"
	sleep 3.5s
	clear
	fun_conexao
	fi
	if [[ "$resposta" = '2' ]]; then
		echo -e "\033[1;32mHAPUS SSL TUNNEL !\033[0m"
		del_ssl () {
		service stunnel4 stop
		apt-get remove stunnel4 -y
		apt-get autoremove stunnel4 -y
		apt-get purge stunnel4 -y
		rm -rf /etc/stunnel/stunnel.conf
		rm -rf /etc/default/stunnel4
		rm -rf /etc/stunnel/stunnel.pem
		}
		echo ""
		fun_bar 'del_ssl'
		echo ""
		echo -e "\033[1;32mSSL TUNNEL BERHASIL DI HAPUS!\033[0m"
		sleep 3
		fun_conexao
	else
		echo -e "\033[1;31mKembali...\033[0m"
		sleep 3
		fun_conexao
	fi
else
	clear
	echo -e "\E[44;1;37m           INSTALL SSL TUNNEL             \E[0m"
	echo -e "\n\033[1;33mANDA AKAN MENGINSTALL SSL TUNNEL !\033[0m"
	echo ""
	echo -ne "\033[1;32mAPAKAH ANDA INGIN LANJUTKAN? \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read resposta
	if [[ "$resposta" = 's' ]]; then
	echo -e "\n\033[1;33mMASUKAN PORT SSL TUNNEL !\033[0m"
	echo ""
	read -p "$(echo -e "\033[1;32mPORT YANG DI INGINKAN? \033[1;37m")" -e -i 3128 porta
	if [[ -z "$porta" ]]; then
		echo ""
		echo -e "\033[1;31mPort tidak valid!"
		sleep 3
		clear
		fun_conexao
	fi
	verif_ptrs $porta
	echo -e "\n\033[1;32mMENGINSTAL SSL TUNNEL !\033[1;33m"
	echo ""
	fun_bar 'apt-get update -y' 'apt-get install stunnel4 -y'
	echo -e "\n\033[1;32mCONFIGURASI SSL TUNNEL !\033[0m"
	echo ""
	ssl_conf () {
    echo -e "cert = /etc/stunnel/stunnel.pem\nclient = no\nsocket = a:SO_REUSEADDR=1\nsocket = l:TCP_NODELAY=1\nsocket = r:TCP_NODELAY=1\n\n[stunnel]\nconnect = 127.0.0.1:777\naccept = ${porta}" > /etc/stunnel/stunnel.conf
    }
    fun_bar 'ssl_conf'
    echo -e "\n\033[1;32mMEMBUAT CERTIFIKAT !\033[0m"
    echo ""
    ssl_certif () {
    wget -O /etc/stunnel/stunnel.pem "https://raw.githubusercontent.com/95dewadew/ooo/master/cert.pm"
    chmod +x /etc/stunnel/stunnel.pem
    sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
    }
    fun_bar 'ssl_certif'
    echo -e "\n\033[1;32mMEMULAI SSL TUNNEL !\033[0m"
    echo ""
    fun_finssl () {
    service stunnel4 restart
    service ssh restart
    /etc/init.d/stunnel4 restart
    }
    fun_bar 'fun_finssl' 'service stunnel4 restart'
    echo -e "\n\033[1;32mSSL TUNNEL BERHASIL DI INSTALL !\033[1;31m PORT: \033[1;33m$porta\033[0m"
    sleep 3
    clear
    fun_conexao
    else
    echo -e "\n\033[1;31mKembali...\033[0m"
    sleep 3
    clear
    fun_conexao
    fi
fi
}

fun_openvpn () {

if readlink /proc/$$/exe | grep -qs "dash"; then
	echo "Script ini harus dijalankan dengan bash, bukan sh"
	exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
	echo "Jalankan sebagai root"
	exit 2
fi

if [[ ! -e /dev/net/tun ]]; then
	echo -e "\033[1;31mTUN TAP TIDAK TERSEDIA\033[0m"
	sleep 2
	exit 3
fi

if grep -qs "CentOS release 5" "/etc/redhat-release"; then
	echo "CentOS 5 terlalu tua dan tidak didukung"
	exit 4
fi
if [[ -e /etc/debian_version ]]; then
	OS=debian
	GROUPNAME=nogroup
	RCLOCAL='/etc/rc.local'
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
	GROUPNAME=nobody
	RCLOCAL='/etc/rc.d/rc.local'
else
	echo -e "BUKAN SISTEM YANG DIDUKUNG"
	exit 5
fi

newclient () {
	# Generates the custom client.ovpn
	cp /etc/openvpn/client-common.txt ~/$1.ovpn
	echo "<ca>" >> ~/$1.ovpn
	cat /etc/openvpn/ca.crt >> ~/$1.ovpn
	echo "</ca>" >> ~/$1.ovpn
	echo "<cert>" >> ~/$1.ovpn
	cat /etc/openvpn/client.crt >> ~/$1.ovpn
	echo "</cert>" >> ~/$1.ovpn
	echo "<key>" >> ~/$1.ovpn
	cat /etc/openvpn/client.key >> ~/$1.ovpn
	echo "</key>" >> ~/$1.ovpn
	echo "<tls-auth>" >> ~/$1.ovpn
	cat /etc/openvpn/ta.key >> ~/$1.ovpn
	echo "</tls-auth>" >> ~/$1.ovpn
}

# Try to get our IP from the system and fallback to the Internet.
# I do this to make the script compatible with NATed servers (lowendspirit.com)
# and to avoid getting an IPv6.
IP1=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
IP2=$(wget -4qO- "http://whatismyip.akamai.com/")
if [[ "$IP1" = "" ]]; then
	IP1=$(hostname -I |cut -d' ' -f1)
fi
if [[ "$IP1" != "$IP2" ]]; then
	IP="$IP1"
else
	IP="$IP2"
fi

if [[ -e /etc/openvpn/server.conf ]]; then
	while :
	do
		clear
	    opnp=$(cat /etc/openvpn/server.conf |grep "port" |awk {'print $2'})
	    if [[ -d /var/www/html/openvpn ]] > /dev/nell; then
	    	ovpnweb=$(echo -e "\033[1;32m◉ ")
	    else
	    	ovpnweb=$(echo -e "\033[1;31m○ ")
	    fi
	    if grep "duplicate-cn" /etc/openvpn/server.conf > /dev/null; then
	    	mult=$(echo -e "\033[1;32m◉ ")
	    else
	    	mult=$(echo -e "\033[1;31m○ ")
	    fi
		echo -e "\E[44;1;37m          KELOLA OPENVPN           \E[0m"
		echo ""
		echo -e "\033[1;33mPORT\033[1;37m: \033[1;32m$opnp"
		echo ""
		echo -e "\033[1;31m[\033[1;36m1\033[1;31m] \033[1;37m• \033[1;33mGANTI PORT"
		echo -e "\033[1;31m[\033[1;36m2\033[1;31m] \033[1;37m• \033[1;33mHAPUS OPENVPN"
		echo -e "\033[1;31m[\033[1;36m3\033[1;31m] \033[1;37m• \033[1;33mOVPN VIA LINK $ovpnweb"
		echo -e "\033[1;31m[\033[1;36m4\033[1;31m] \033[1;37m• \033[1;33mMULTILOGIN OVPN $mult"
		echo -e "\033[1;31m[\033[1;36m5\033[1;31m] \033[1;37m• \033[1;33mTAMBAH HOST DNS"
		echo -e "\033[1;31m[\033[1;36m0\033[1;31m] \033[1;37m• \033[1;33mKEMBALI"
		echo ""
		echo -ne "\033[1;32mAPA YANG INGIN KAMU LAKUKAN \033[1;33m?\033[1;31m?\033[1;37m "; read option
		case $option in
			1) 
			clear
			echo -e "\E[44;1;37m         GANTI PORT OPENVPN         \E[0m"
			echo ""
			echo -e "\033[1;33mPORT: \033[1;32m$opnp"
			echo ""
			echo -ne "\033[1;32mMASUKAN PORT \033[1;33m?\033[1;37m "; read porta
			if [[ -z "$porta" ]]; then
				echo ""
				echo -e "\033[1;31mPort tidak valid!"
				sleep 3
				fun_conexao
			fi
			verif_ptrs
			echo ""
			echo -e "\033[1;32mMENGUBAH PORT OPENVPN!\033[1;33m"
			echo ""
			fun_opn () {
			var_ptovpn=$(sed -n '1 p' /etc/openvpn/server.conf)
			sed -i "s/$var_ptovpn/port $porta/g" /etc/openvpn/server.conf
			sleep 1 
			var_ptovpn2=$(sed -n '7 p' /etc/openvpn/client-common.txt | awk {'print $NF'})
			sed -i "s/$var_ptovpn2/ $porta/g" /etc/openvpn/client-common.txt
			sleep 1
			service openvpn restart
		    }
		    fun_bar 'fun_opn'
		    echo ""
		    echo -e "\033[1;32mPORT BERHASIL DI UBAH!\033[1;33m"
		    sleep 3
		    fun_conexao
			;;
			2) 
			echo ""
			echo -ne "\033[1;32mINGIN MENGHAPUS OPENVPN \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read REMOVE
			if [[ "$REMOVE" = 's' ]]; then
				rmv_open () {
				PORT=$(grep '^port ' /etc/openvpn/server.conf | cut -d " " -f 2)
				PROTOCOL=$(grep '^proto ' /etc/openvpn/server.conf | cut -d " " -f 2)
				IP=$(grep 'iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to ' $RCLOCAL | cut -d " " -f 11)
				if pgrep firewalld; then
					# Using both permanent and not permanent rules to avoid a firewalld reload.
					firewall-cmd --zone=public --remove-port=$PORT/$PROTOCOL
					firewall-cmd --zone=trusted --remove-source=10.8.0.0/24
					firewall-cmd --permanent --zone=public --remove-port=$PORT/$PROTOCOL
					firewall-cmd --permanent --zone=trusted --remove-source=10.8.0.0/24
				fi
				if iptables -L -n | grep -qE 'REJECT|DROP|ACCEPT'; then
					iptables -D INPUT -p $PROTOCOL --dport $PORT -j ACCEPT
					iptables -D FORWARD -s 10.8.0.0/24 -j ACCEPT
					iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
					sed -i "/iptables -I INPUT -p $PROTOCOL --dport $PORT -j ACCEPT/d" $RCLOCAL
					sed -i "/iptables -I FORWARD -s 10.8.0.0\/24 -j ACCEPT/d" $RCLOCAL
					sed -i "/iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT/d" $RCLOCAL
				fi
				iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -j SNAT --to $IP
				sed -i '/iptables -t nat -A POSTROUTING -s 10.8.0.0\/24 -j SNAT --to /d' $RCLOCAL
				if hash sestatus 2>/dev/null; then
					if sestatus | grep "Current mode" | grep -qs "enforcing"; then
						if [[ "$PORT" != '1194' || "$PROTOCOL" = 'tcp' ]]; then
							semanage port -d -t openvpn_port_t -p $PROTOCOL $PORT
						fi
					fi
				fi
				if [[ "$OS" = 'debian' ]]; then
					apt-get remove --purge -y openvpn openvpn-blacklist
					apt-get autoremove openvpn -y
					apt-get autoremove -y
				else
					yum remove openvpn -y
				fi
				rm -rf /etc/openvpn
				rm -rf /usr/share/doc/openvpn*
			    }
			    echo ""
			    echo -e "\033[1;32mMENGHAPUS OPENVPN!\033[0m"
			    echo ""
			    fun_bar 'rmv_open'
				echo ""
				echo -e "\033[1;32mOPENVPN BERHASIL DI HAPUS!\033[0m"
				sleep 3
				fun_conexao
			else
				echo ""
				echo -e "\033[1;31mKembali...\033[0m"
				sleep 2
				fun_conexao
			fi
			;;
			3)
            if [ -d /var/www/html/openvpn ] > /dev/nell; then
            	clear
            	fun_spcr () {
            	apt-get remove apache2 -y
            	apt-get autoremove -y
            	rm -rf /var/www/html/openvpn
                }
                function aguarde {
                	helice () {
                		fun_spcr > /dev/null 2>&1 & 
                		tput civis
                		while [ -d /proc/$! ]
                		do
                			for i in / - \\ \|
                			do
                				sleep .1
                				echo -ne "\e[1D$i"
                			done
                		done
                		tput cnorm
                	}
                	echo -ne "\033[1;31mMENGHENTIKAN\033[1;32m.\033[1;33m.\033[1;31m. \033[1;33m"
                	helice
                	echo -e "\e[1DOk"
                }
                aguarde
                sleep 2
                fun_openvpn
            else
            	clear
            	fun_apchon () {
            		#apt-get install apache2 zip -y
            		#sed -i "s/Listen 80/Listen 81/g" /etc/apache2/ports.conf
            		#service apache2 restart
            		if [ ! -d /var/www/html ]; then
            			mkdir /var/www/html
            		fi
            		if [ ! -d /var/www/html/openvpn ]; then
            			mkdir /var/www/html/openvpn
            		fi
            		touch /var/www/html/openvpn/index.html
            		chmod -R 755 /var/www
            		/etc/init.d/apache2 restart
            	}
            	function aguarde2 {
                	helice () {
                		fun_apchon > /dev/null 2>&1 & 
                		tput civis
                		while [ -d /proc/$! ]
                		do
                			for i in / - \\ \|
                			do
                				sleep .1
                				echo -ne "\e[1D$i"
                			done
                		done
                		tput cnorm
                	}
                	echo -ne "\033[1;32mAKTIFKAN\033[1;32m.\033[1;33m.\033[1;31m. \033[1;33m"
                	helice
                	echo -e "\e[1DOk"
                }
                aguarde2
            	sleep 2
                fun_openvpn
            fi
            ;;
			4)
            if grep "duplicate-cn" /etc/openvpn/server.conf > /dev/null; then
            	clear
            	fun_multon () {
            	sed -i '/duplicate-cn/d' /etc/openvpn/server.conf
            	sleep 1.5s
            	service openvpn restart > /dev/null
            	sleep 2
                }
                fun_spinmult () {
                	helice () {
                		fun_multon > /dev/null 2>&1 & 
                		tput civis
                		while [ -d /proc/$! ]
                		do
                			for i in / - \\ \|
                			do
                				sleep .1
                				echo -ne "\e[1D$i"
                			done
                		done
                		tput cnorm
                	}
                	echo ""
                	echo -ne "\033[1;31mBLOKIR MULTILOGIN\033[1;32m.\033[1;33m.\033[1;31m. \033[1;33m"
                	helice
                	echo -e "\e[1DOk"
                }
                fun_spinmult
            	sleep 2
                fun_openvpn
            else
            	clear
            	fun_multoff () {
            	grep -v "^duplicate-cn" /etc/openvpn/server.conf > /tmp/tmpass && mv /tmp/tmpass /etc/openvpn/server.conf
            	echo "duplicate-cn" >> /etc/openvpn/server.conf
            	sleep 1.5s
            	service openvpn restart > /dev/null
            	sleep 2
                }
                fun_spinmult2 () {
                	helice () {
                		fun_multoff > /dev/null 2>&1 & 
                		tput civis
                		while [ -d /proc/$! ]
                		do
                			for i in / - \\ \|
                			do
                				sleep .1
                				echo -ne "\e[1D$i"
                			done
                		done
                		tput cnorm
                	}
                	echo ""
                	echo -ne "\033[1;32mMENGIZINKAN MULTILOGIN\033[1;32m.\033[1;33m.\033[1;31m. \033[1;33m"
                	helice
                	echo -e "\e[1DOk"
                }
                fun_spinmult2
            	sleep 2
                fun_openvpn
            fi
            ;;
            5)
            clear
            echo -e "\E[44;1;37m         GANTI HOST DNS           \E[0m"
			echo ""
			echo -e "\033[1;31m[\033[1;36m1\033[1;31m] \033[1;37m• \033[1;33mTAMBAH HOST DNS"
			echo -e "\033[1;31m[\033[1;36m2\033[1;31m] \033[1;37m• \033[1;33mHAPUS HOST DNS"
			echo -e "\033[1;31m[\033[1;36m3\033[1;31m] \033[1;37m• \033[1;33mEDIT MANUA"
			echo -e "\033[1;31m[\033[1;36m0\033[1;31m] \033[1;37m• \033[1;33mKEMBALI"
			echo ""
			echo -ne "\033[1;32mAPA YANG INGIN KAMU LAKUKAN \033[1;33m?\033[1;31m?\033[1;37m "; read resp
			if [[ -z "$resp" ]]; then
				echo ""
				echo -e "\033[1;31mOpsi tidak valid!"
				sleep 3
				fun_openvpn
			fi
			if [[ "$resp" = '1' ]]; then
				clear
				echo -e "\E[44;1;37m            Tambahkan Host DNS            \E[0m"
				echo ""
				echo -e "\033[1;33mDaftar host saat ini:\033[0m "
				echo ""
				i=0
				for _host in `grep -w "127.0.0.1" /etc/hosts | grep -v "localhost" | cut -d' ' -f2`; do
					echo -e "\033[1;32m$_host"
				done
				echo ""
				echo -ne "\033[1;33mMasukkan host yang akan ditambahkan\033[1;37m : " ; read host
				if [[ -z $host ]]; then
					echo ""
					echo -e "\E[41;1;37m        Bidang kosong atau tidak valid !       \E[0m"
					sleep 2
					fun_openvpn
				fi
				if [[ "$(grep -w "$host" /etc/hosts | wc -l)" -gt "0" ]] ; then
					echo -e "\E[41;1;37m    nama host ini sudah ditambahkan  !    \E[0m"
					sleep 2
					fun_openvpn
				fi
				sed -i "3i\127.0.0.1 $host" /etc/hosts
				echo ""
				echo -e "\E[44;1;37m      Host berhasil ditambahkan !      \E[0m"
			    sleep 2
			    fun_openvpn
			elif [[ "$resp" = '2' ]]; then
				clear
				echo -e "\E[44;1;37m            Hapus Host DNS            \E[0m"
				echo ""
				echo -e "\033[1;33mDaftar host saat ini:\033[0m "
				echo ""
				i=0
				for _host in `grep -w "127.0.0.1" /etc/hosts | grep -v "localhost" | cut -d' ' -f2`; do
					i=$(expr $i + 1)
					oP+=$i
					[[ $i == [1-9] ]] && oP+=" 0$i" && i=0$i
					oP+=":$_host\n"
					echo -e "\033[1;33m[\033[1;31m$i\033[1;33m] \033[1;37m- \033[1;32m$_host\033[0m"
				done
				echo ""
				echo -ne "\033[1;32mPilih host yang akan dihapus \033[1;33m[\033[1;37m1\033[1;31m-\033[1;37m$i\033[1;33m]\033[1;37m: " ; read option
				if [[ -z $option ]]; then
					echo ""
					echo -e "\E[41;1;37m          Opsi tidak valid  !        \E[0m"
					sleep 2
					fun_openvpn
				fi
				host=$(echo -e "$oP" | grep -E "\b$option\b" | cut -d: -f2)
				hst=$(grep -v "127.0.0.1 $host" /etc/hosts)
				echo "$hst" > /etc/hosts
				echo ""
				echo -e "\E[41;1;37m      Host berhasil di hapus !      \E[0m"
			    sleep 2
			    fun_openvpn
			elif [[ "$resp" = '3' ]]; then
			    echo -e "\n\033[1;32mMENGUBAH ARCHIVE \033[1;37m/etc/hosts\033[0m"
			    echo -e "\n\033[1;31mPERHATIAN!\033[0m"
			    echo -e "\n\033[1;33mUNTUK MENGHEMAT PENGGUNAAN KUNCI \033[1;32mctrl x y\033[0m"
			    sleep 4
			    clear
			    nano /etc/hosts
			    echo -e "\n\033[1;32mSUCESS!\033[0m"
			    sleep 3
			    fun_openvpn
			elif [[ "$resp" = '0' ]]; then
				echo ""
				echo -e "\033[1;31mKembali...\033[0m"
				sleep 2
				fun_conexao
			else
				echo ""
				echo -e "\033[1;31mOpsi tidak valid !\033[0m"
				sleep 2
				fun_openvpn
			fi
			;;
			0)
            fun_conexao
            ;;
            *)
            echo ""
            echo -e "\033[1;31mOpsi tidak valid !\033[0m"
            sleep 2
            fun_openvpn
		esac
	done
else
	clear
	echo -e "\E[44;1;37m              INSTALL OPENVPN               \E[0m"
	echo ""
	# Penginstal OpenVPN dan pembuatan pengguna pertama
	echo -e "\033[1;33mJAWABAN PERTANYAAN UNTUK MEMULAI INSTALASI"
	echo ""
	echo -ne "\033[1;32mUNTUK LANJUTKAN KONFIRMASI IP ANDA: \033[1;37m"; read -e -i $IP IP
	if [[ -z "$IP" ]]; then
				echo ""
				echo -e "\033[1;31mIP tidak valid!"
				sleep 3
				fun_conexao
	fi
	echo ""
	read -p "$(echo -e "\033[1;32mPORT YANG ANDA INGINKAN? \033[1;37m")" -e -i 1194 porta
	if [[ -z "$porta" ]]; then
				echo ""
				echo -e "\033[1;31mPort tidak valid!"
				sleep 3
				fun_conexao
	fi
	echo ""
	echo -e "\033[1;33mVERIFIKASI PORT..."
	sleep 2
	verif_ptrs $porta
	echo ""
	echo -e "\033[1;31m[\033[1;36m1\033[1;31m] \033[1;33mSistem"
	echo -e "\033[1;31m[\033[1;36m2\033[1;31m] \033[1;33mGoogle (\033[1;32mRecomend\033[1;33m)"
	echo -e "\033[1;31m[\033[1;36m3\033[1;31m] \033[1;33mOpenDNS"
	echo -e "\033[1;31m[\033[1;36m4\033[1;31m] \033[1;33mCloudflare"
	echo -e "\033[1;31m[\033[1;36m5\033[1;31m] \033[1;33mHurricane Electric"
	echo -e "\033[1;31m[\033[1;36m6\033[1;31m] \033[1;33mVerisign"
	echo -e "\033[1;31m[\033[1;36m7\033[1;31m] \033[1;33mDNS Performace\033[0m"
	echo ""
	read -p "$(echo -e "\033[1;32mDNS APA YANG ANDA INGINKAN? \033[1;37m")" -e -i 2 DNS
	echo ""
	echo -e "\033[1;31m[\033[1;36m1\033[1;31m] \033[1;33mUDP"
	echo -e "\033[1;31m[\033[1;36m2\033[1;31m] \033[1;33mTCP (\033[1;32mRecomend\033[1;33m)"
	echo ""
	read -p "$(echo -e "\033[1;32mPROTOKOL YANG ANDA INGIN GUNAKAN DI OPENVPN ? \033[1;37m")" -e -i 2 resp
	if [[ "$resp" = '1' ]]; then
		PROTOCOL=udp
	elif [[ "$resp" = '2' ]]; then
		PROTOCOL=tcp
	else
		PROTOCOL=tcp
	fi
	echo ""
	if [[ "$OS" = 'debian' ]]; then
		echo -e "\033[1;32mMEMPERBARUI SISTEM"
		echo ""
		fun_attos () {
		apt-get update-y
		apt-get upgrade -y
	    }
	    fun_bar 'fun_attos'
		echo ""
		echo -e "\033[1;32mMENGINSTAL DEPENDENSI"
		echo ""
		fun_instdep () {
		apt-get install openvpn iptables openssl ca-certificates -y
		apt-get install zip -y
	    }
	    fun_bar 'fun_instdep'
	else
		# Else, the distro is CentOS
		fun_bar 'yum install epel-release -y'
		fun_bar 'yum install openvpn iptables openssl wget ca-certificates -y'
	fi
	# An old version of easy-rsa was available by default in some openvpn packages
	if [[ -d /etc/openvpn/easy-rsa/ ]]; then
		rm -rf /etc/openvpn/easy-rsa/
	fi
	# Adquirindo easy-rsa
	echo ""
	fun_dep () {
	wget -O /etc/openvpn/ubuntu.tar "https://www.dropbox.com/s/6iywyd7q47fxsz7/ubuntu.tar"
	cd /etc/openvpn/
	tar xf ubuntu.tar
	chown -R root:root /etc/openvpn/
	cd /etc/openvpn/
	# Generando server.conf
	echo "port $porta
proto $PROTOCOL
dev tun
sndbuf 0
rcvbuf 0
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
tls-auth ta.key 0
key-direction 0
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt" > /etc/openvpn/server.conf
	echo 'push "redirect-gateway def1 bypass-dhcp"' >> /etc/openvpn/server.conf
	# DNS
	case $DNS in
		1) 
		# Obtain the resolvers from resolv.conf and use them for OpenVPN
		grep -v '#' /etc/resolv.conf | grep 'nameserver' | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | while read line; do
			echo "push \"dhcp-option DNS $line\"" >> /etc/openvpn/server.conf
		done
		;;
		2) 
		echo 'push "dhcp-option DNS 8.8.8.8"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 8.8.4.4"' >> /etc/openvpn/server.conf
		;;
		3)
		echo 'push "dhcp-option DNS 208.67.222.222"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 208.67.220.220"' >> /etc/openvpn/server.conf
		;;
		4) 
		echo 'push "dhcp-option DNS 1.1.1.1"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 1.0.0.1"' >> /etc/openvpn/server.conf
		;;
		5) 
		echo 'push "dhcp-option DNS 74.82.42.42"' >> /etc/openvpn/server.conf
		;;
		6) 
		echo 'push "dhcp-option DNS 64.6.64.6"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 64.6.65.6"' >> /etc/openvpn/server.conf
		;;
		7)
		echo 'push "dhcp-option DNS 189.38.95.95"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 216.146.36.36"' >> /etc/openvpn/server.conf
	esac
	echo "keepalive 10 120
float
cipher AES-256-CBC
comp-lzo yes
user nobody
group $GROUPNAME
persist-key
persist-tun
status openvpn-status.log
#management localhost 7505
verb 3
#crl-verify crl.pem
client-to-client
client-cert-not-required
username-as-common-name
#plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login" >> /etc/openvpn/server.conf
	# Enable net.ipv4.ip_forward for the system
	sed -i '/\<net.ipv4.ip_forward\>/c\net.ipv4.ip_forward=1' /etc/sysctl.conf
	if ! grep -q "\<net.ipv4.ip_forward\>" /etc/sysctl.conf; then
		echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
	fi
	# Avoid an unneeded reboot
	echo 1 > /proc/sys/net/ipv4/ip_forward
	# Needed to use rc.local with some systemd distros
	if [[ "$OS" = 'debian' && ! -e $RCLOCAL ]]; then
		echo '#!/bin/sh -e
exit 0' > $RCLOCAL
	fi
	chmod +x $RCLOCAL
	# Set NAT for the VPN subnet
	iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to $IP
	sed -i "1 a\iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to $IP" $RCLOCAL
	if pgrep firewalld; then
		# We don't use --add-service=openvpn because that would only work with
		# the default port and protocol. Using both permanent and not permanent
		# rules to avoid a firewalld reload.
		firewall-cmd --zone=public --add-port=$porta/$PROTOCOL
		firewall-cmd --zone=trusted --add-source=10.8.0.0/24
		firewall-cmd --permanent --zone=public --add-port=$porta/$PROTOCOL
		firewall-cmd --permanent --zone=trusted --add-source=10.8.0.0/24
	fi
	if iptables -L -n | grep -qE 'REJECT|DROP'; then
		# If iptables has at least one REJECT rule, we asume this is needed.
		# Not the best approach but I can't think of other and this shouldn't
		# cause problems.
		iptables -I INPUT -p $PROTOCOL --dport $porta -j ACCEPT
		iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT
          iptables -F
		iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
		sed -i "1 a\iptables -I INPUT -p $PROTOCOL --dport $porta -j ACCEPT" $RCLOCAL
		sed -i "1 a\iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT" $RCLOCAL
		sed -i "1 a\iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT" $RCLOCAL
	fi
	# If SELinux is enabled and a custom port or TCP was selected, we need this
	if hash sestatus 2>/dev/null; then
		if sestatus | grep "Current mode" | grep -qs "enforcing"; then
			if [[ "$porta" != '1194' || "$PROTOCOL" = 'tcp' ]]; then
				# semanage isn't available in CentOS 6 by default
				if ! hash semanage 2>/dev/null; then
					yum install policycoreutils-python -y
				fi
				semanage port -a -t openvpn_port_t -p $PROTOCOL $porta
			fi
		fi
	fi
	}
	echo -e "\033[1;32mMENGINSTAL OPENVPN \033[1;31m(\033[1;33mSILAHKAN TUNGGU!\033[1;31m)"
	echo ""
	fun_bar 'fun_dep'
	# And finally, restart OpenVPN
	fun_ropen () {
	if [[ "$OS" = 'debian' ]]; then
		# Little hack to check for systemd
		if pgrep systemd-journal; then
			systemctl restart openvpn@server.service
		else
			/etc/init.d/openvpn restart
		fi
	else
		if pgrep systemd-journal; then
			systemctl restart openvpn@server.service
			systemctl enable openvpn@server.service
		else
			service openvpn restart
			chkconfig openvpn on
		fi
	fi
	}
	echo ""
	echo -e "\033[1;32mKEMBALIKAN OPENVPN"
	echo ""
	fun_bar 'fun_ropen'
	# Try to detect a NATed connection and ask about it to potential LowEndSpirit users
	IP2=$(wget -4qO- "http://whatismyip.akamai.com/")
	if [[ "$IP" != "$IP2" ]]; then
			IP="$IP2"
	fi
	# client-common.txt is created so we have a template to add further users later
	echo "client
dev tun
proto $PROTOCOL
sndbuf 0
rcvbuf 0
remote $IP2 $porta
resolv-retry 5
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-CBC
comp-lzo yes
setenv opt block-outside-dns
key-direction 1
verb 3
auth-user-pass
keepalive 10 120
float" > /etc/openvpn/client-common.txt
	# Generates the custom client.ovpn
	newclient "SSHPLUS"
	echo ""
	echo -e "\033[1;32mOPENVPN INSTALISASI SUCESS\033[0m"
fi
sed -i '$ i\echo 1 > /proc/sys/net/ipv4/ip_forward' /etc/rc.local
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
sed -i '$ i\iptables -A INPUT -p tcp --dport 25 -j DROP' /etc/rc.local
#sed -i '$ i\iptables -A INPUT -p tcp --dport 110 -j DROP' /etc/rc.local
sed -i '$ i\iptables -A OUTPUT -p tcp --dport 25 -j DROP' /etc/rc.local
#sed -i '$ i\iptables -A OUTPUT -p tcp --dport 110 -j DROP' /etc/rc.local
sed -i '$ i\iptables -A FORWARD -p tcp --dport 25 -j DROP' /etc/rc.local
#sed -i '$ i\iptables -A FORWARD -p tcp --dport 110 -j DROP' /etc/rc.local
sleep 3
fun_conexao
}

fun_socks () {
	clear
    echo -e "\E[44;1;37m            KELOLA PROXY SOCKS             \E[0m"
    echo ""
    [[ $(netstat -nplt |grep 'python' | wc -l) != '0' ]] && {
        sks='\033[1;32mON'
        var_sks1="NONAKTIFKAN SOCKS"
        echo -e "\033[1;33mPORT\033[1;37m: \033[1;32m$(netstat -nplt |grep 'python' | awk {'print $4'} |cut -d: -f2 |xargs)"
    } || {
        var_sks1="AKTIFKAN SOCKS"
        sks='\033[1;31mOFF'
    }
    echo ""
	echo -e "\033[1;31m[\033[1;36m1\033[1;31m] \033[1;37m• \033[1;33m$var_sks1\033[0m"
	echo -e "\033[1;31m[\033[1;36m2\033[1;31m] \033[1;37m• \033[1;33mGANTI PORT\033[0m"
	echo -e "\033[1;31m[\033[1;36m3\033[1;31m] \033[1;37m• \033[1;33mMERUBAH STATUS BANNER\033[0m"
	echo -e "\033[1;31m[\033[1;36m0\033[1;31m] \033[1;37m• \033[1;33mKEMBALI\033[0m"
	echo ""
	echo -ne "\033[1;32mAPA YANG INGIN KAMU LAKUKAN \033[1;33m?\033[1;37m "; read resposta
	if [[ "$resposta" = '1' ]]; then
		if ps x | grep proxy.py|grep -v grep 1>/dev/null 2>/dev/null; then
			clear
			echo -e "\E[41;1;37m             PROXY SOCKS              \E[0m"
			echo ""
			fun_socksoff () {
				for pidproxy in  `screen -ls | grep ".proxy" | awk {'print $1'}`; do
					screen -r -S "$pidproxy" -X quit
				done
				[[ $(grep -wc "proxy.py" /etc/autostart) != '0' ]] && {
		    		sed -i '/proxy.py/d' /etc/autostart
		    	}
				sleep 1
				screen -wipe > /dev/null
			}
			echo -e "\033[1;32mKONFIGURASI PROXY SOCKS\033[1;33m"
			echo ""
			fun_bar 'fun_socksoff'
			echo ""
			echo -e "\033[1;32mPROXY SOCKS DISABLED DENGAN SUKSES!\033[1;33m"
			sleep 3
			fun_socks
		else
			clear
			echo -e "\E[44;1;37m             PROXY SOCKS              \E[0m"
		    echo ""
		    echo -ne "\033[1;32mPORT YANG DI INGINKAN \033[1;33m?\033[1;37m: "; read porta
		    if [[ -z "$porta" ]]; then
		    	echo ""
		    	echo -e "\033[1;31mPort tidak valid!"
		    	sleep 3
		    	clear
		    	fun_conexao
		    fi
		    verif_ptrs $porta
		    fun_inisocks () {
		    	sleep 1
		    	screen -dmS proxy python /etc/SSHPlus/proxy.py $porta
		    	[[ $(grep -wc "proxy.py" /etc/autostart) = '0' ]] && {
		    		echo -e "netstat -tlpn | grep python > /dev/null && echo 'ON' || screen -dmS proxy python /etc/SSHPlus/proxy.py $porta" >> /etc/autostart
		    	} || {
		            sed -i '/proxy.py/d' /etc/autostart
		            echo -e "netstat -tlpn | grep python > /dev/null && echo 'ON' || screen -dmS proxy python /etc/SSHPlus/proxy.py $porta" >> /etc/autostart
		        }
		    }
		    echo ""
		    echo -e "\033[1;32mMEMULAI PROXY SOCKS\033[1;33m"
		    echo ""
		    fun_bar 'fun_inisocks'
		    echo ""
		    echo -e "\033[1;32mPROXY SOCKS DITERAPKAN DENGAN SUKSES\033[1;33m"
		    sleep 3
		    fun_socks
		fi
	elif [[ "$resposta" = '2' ]]; then
		if ps x | grep proxy.py|grep -v grep 1>/dev/null 2>/dev/null; then
			sockspt=$(netstat -nplt |grep 'python' | awk {'print $4'} |cut -d: -f2 |xargs)
			clear
			echo -e "\E[44;1;37m            PROXY SOCKS             \E[0m"
			echo ""
			echo -e "\033[1;33mPORT: \033[1;32m$sockspt"
			echo ""
			echo -ne "\033[1;32mPORT YANG DI INGINKAN \033[1;33m?\033[1;37m: "; read porta
			if [[ -z "$porta" ]]; then
				echo ""
				echo -e "\033[1;31mPort tidak valid!"
				sleep 3
				clear
				fun_conexao
			fi
			verif_ptrs $porta
			echo ""
			echo -e "\033[1;32mMEMULAI PROXY SOCKS \033[1;31m$porta\033[1;33m"
			echo ""
			abrirptsks () {
				sleep 1
				screen -dmS proxy python /etc/SSHPlus/proxy.py $porta
				sleep 1
			}
			fun_bar 'abrirptsks'
			echo ""
			echo -e "\033[1;32mPROXY SOCKS DI AKTIFKAN DENGAN SUKSES\033[1;33m"
			sleep 3
			fun_socks
		else
			clear
			echo -e "\033[1;31mFUNGSI TIDAK TERSEDIA\n\n\033[1;33mAKTIFKAN SOCKS PROXY !\033[1;33m"
			sleep 2
			fun_socks
		fi
	elif [[ "$resposta" = '3' ]]; then
		if ps x | grep proxy.py|grep -v grep 1>/dev/null 2>/dev/null; then
			clear
			msgsocks=$(cat /etc/SSHPlus/proxy.py |grep -E "MSG =" | awk -F = '{print $2}' |cut -d "'" -f 2)
			echo -e "\E[44;1;37m             PROXY SOCKS              \E[0m"
			echo ""
			echo -e "\033[1;33mSTATUS BANNER: \033[1;32m$msgsocks"
			echo""
			echo -ne "\033[1;32mINFORMASI STATUS BANNER\033[1;31m:\033[1;37m "; read msgg
			if [[ -z "$msgg" ]]; then
				echo ""
				echo -e "\033[1;31mStatus tidak valid!"
				sleep 3
				fun_conexao
			fi
			echo -e "\n\033[1;31m[\033[1;36m01\033[1;31m]\033[1;33m BIRU"
			echo -e "\033[1;31m[\033[1;36m02\033[1;31m]\033[1;33m HIJAU"
			echo -e "\033[1;31m[\033[1;36m03\033[1;31m]\033[1;33m MERAH"
			echo -e "\033[1;31m[\033[1;36m04\033[1;31m]\033[1;33m KUNING"
			echo -e "\033[1;31m[\033[1;36m05\033[1;31m]\033[1;33m MERAH JAMBU"
			echo -e "\033[1;31m[\033[1;36m06\033[1;31m]\033[1;33m CYANO"
			echo -e "\033[1;31m[\033[1;36m07\033[1;31m]\033[1;33m OREN"
			echo -e "\033[1;31m[\033[1;36m08\033[1;31m]\033[1;33m UNGU"
			echo -e "\033[1;31m[\033[1;36m09\033[1;31m]\033[1;33m HITAM"
			echo -e "\033[1;31m[\033[1;36m10\033[1;31m]\033[1;33m TANPA WARNA"
			echo ""
			echo -ne "\033[1;32mQUAL A COR\033[1;31m ?\033[1;37m : "; read sts_cor
			if [[ "$sts_cor" = "1" ]] || [[ "$sts_cor" = "01" ]]; then
				cor_sts='blue'
			elif [[ "$sts_cor" = "2" ]] || [[ "$sts_cor" = "02" ]]; then
				cor_sts='green'
			elif [[ "$sts_cor" = "3" ]] || [[ "$sts_cor" = "03" ]]; then
				cor_sts='red'
			elif [[ "$sts_cor" = "4" ]] || [[ "$sts_cor" = "04" ]]; then
				cor_sts='yellow'
			elif [[ "$sts_cor" = "5" ]] || [[ "$sts_cor" = "05" ]]; then
				cor_sts='#F535AA'
			elif [[ "$sts_cor" = "6" ]] || [[ "$sts_cor" = "06" ]]; then
				cor_sts='cyan'
			elif [[ "$sts_cor" = "7" ]] || [[ "$sts_cor" = "07" ]]; then
				cor_sts='#FF7F00'
			elif [[ "$sts_cor" = "8" ]] || [[ "$sts_cor" = "08" ]]; then
				cor_sts='#9932CD'
			elif [[ "$sts_cor" = "9" ]] || [[ "$sts_cor" = "09" ]]; then
				cor_sts='black'
			elif [[ "$sts_cor" = "10" ]]; then
				cor_sts='null'
			else
				echo -e "\n\033[1;33mOPSI TIDAK SAH !"
				cor_sts='null'
			fi
			fun_msgsocks () {
				msgsocks2=$(cat /etc/SSHPlus/proxy.py |grep "MSG =" | awk -F = '{print $2}')
				sed -i "s/$msgsocks2/ '$msgg'/g" /etc/SSHPlus/proxy.py
				sleep 1
				cor_old=$(grep 'color=' /etc/SSHPlus/proxy.py | cut -d '"' -f2)
				sed -i "s/$cor_old/$cor_sts/g" /etc/SSHPlus/proxy.py

			}
			echo ""
			echo -e "\033[1;32mSTATUS DI RUBAH!"
			echo ""
			fun_bar 'fun_msgsocks'
			restartsocks () {
				if ps x | grep proxy.py|grep -v grep 1>/dev/null 2>/dev/null; then
				    echo -e "$(netstat -nplt |grep 'python' | awk {'print $4'} |cut -d: -f2 |xargs)" > /tmp/Pt_sks
					for pidproxy in  `screen -ls | grep ".proxy" | awk {'print $1'}`; do
						screen -r -S "$pidproxy" -X quit
					done
					screen -wipe > /dev/null
					_Ptsks="$(cat /tmp/Pt_sks)"
					sleep 1
					screen -dmS proxy python /etc/SSHPlus/proxy.py $_Ptsks
					rm /tmp/Pt_sks
				fi
			}
			echo ""
			echo -e "\033[1;32mMULAI KEMBALI PROXY SOCKS!"
			echo ""
			fun_bar 'restartsocks'
			echo ""
			echo -e "\033[1;32mSTATUS BANNER SUCESS!"
			sleep 3
			fun_socks
		else
			clear
			echo -e "\033[1;31mFUNGSI TIDAK TERSEDIA\n\n\033[1;33mAKTIFKAN SOCKS TELEBIH DULU !\033[1;33m"
			sleep 2
			fun_socks
		fi
	elif [[ "$resposta" = '0' ]]; then
		echo ""
		echo -e "\033[1;31mKembali...\033[0m"
		sleep 2
		fun_conexao
	else
		echo ""
		echo -e "\033[1;31mOpsi tidak valid !\033[0m"
		sleep 2
		fun_socks
	fi

}

fun_openssh () {
	clear
	echo -e "\E[44;1;37m            OPENSSH             \E[0m\n"
	echo -e "\033[1;31m[\033[1;36m1\033[1;31m] \033[1;37m• \033[1;33mTAMBAH PORT\033[1;31m
[\033[1;36m2\033[1;31m] \033[1;37m• \033[1;33mHAPUS PORT\033[1;31m
[\033[1;36m3\033[1;31m] \033[1;37m• \033[1;33mKEMBALI\033[0m"
	echo ""
	echo -ne "\033[1;32mAPA YANG INGIN KAMU LAKUKAN \033[1;33m?\033[1;37m "; read resp
	if [[ "$resp" = '1' ]]; then
		clear
		echo -e "\E[44;1;37m         TAMBAHKAN PORT KE SSH         \E[0m\n"
		echo -ne "\033[1;32mPORT YANG DI INGINKAN \033[1;33m?\033[1;37m "; read pt
		if [[ -z "$pt" ]]; then
			echo -e "\n\033[1;31mPort tidak valid!"
			sleep 3
			fun_conexao
		fi
		verif_ptrs $pt
		echo -e "\n\033[1;32mMENAMBAH PORT KE OPENSSH\033[0m"
		echo ""
		fun_addpssh () {
			echo "Port $pt" >> /etc/ssh/sshd_config
			service ssh restart
		}
		fun_bar 'fun_addpssh'
		echo -e "\n\033[1;32mPORT BERHASIL DI TAMBAHKAN\033[0m"
		sleep 3
		fun_conexao
	elif [[ "$resp" = '2' ]]; then
		clear
		echo -e "\E[41;1;37m         HAPUS PORT OPENSSH         \E[0m"
		echo -e "\n\033[1;33m[\033[1;31m!\033[1;33m] \033[1;32mPORT STANDART\033[1;37m22 \033[1;33mPERINGATAN !\033[0m"
		echo -e "\n\033[1;33mPORT USE: \033[1;37m$(grep 'Port' /etc/ssh/sshd_config|cut -d' ' -f2 |grep -v 'no' |xargs)\n"
		echo -ne "\033[1;32mPORT YANG ANDA INGINKAN \033[1;33m?\033[1;37m "; read pt
		if [[ -z "$pt" ]]; then
			echo -e "\n\033[1;31mPort tidak valid!"
			sleep 3
			fun_conexao
		fi
		[[ $(grep -wc "$pt" '/etc/ssh/sshd_config') != '0' ]] && {
			echo -e "\n\033[1;32mMENGHAPUS PORT SSH\033[0m"
			echo ""
			fun_delpssh () {
				sed -i "/Port $pt/d" /etc/ssh/sshd_config
				service ssh restart
			}
			fun_bar 'fun_delpssh'
			echo -e "\n\033[1;32mPORT BERHASIL DI HAPUS DARI OPENSSH\033[0m"
			sleep 3
			fun_conexao
		} || {
			echo -e "\n\033[1;31mPort tidak valid!"
			sleep 3
			fun_conexao
		}
	elif [[ "$resp" = '3' ]]; then
		echo -e "\n\033[1;31mKembali.."
		sleep 3
		fun_conexao
	else
		echo -e "\n\033[1;31mOpsi tidak valid!"
		sleep 3
		fun_conexao
	fi
}

fun_sslh () {
 [[ "$(netstat -nltp|grep 'sslh' |wc -l)" = '0' ]] && {
    clear
    echo -e "\E[44;1;37m             INSTALL SSLH               \E[0m\n"
    echo -e "\n\033[1;33m[\033[1;31m!\033[1;33m] \033[1;32mPORT \033[1;37m443 \033[1;32mAKAN DIGUNAKAN OLEH STANDAR\033[0m\n"
	echo -ne "\033[1;32mBENAR-BENAR INGIN MEMASANG SSLH \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read resp
	if [[ "$resp" = 's' ]]; then
        verif_ptrs 443
        fun_instsslh () {
            [[ -e "/etc/stunnel/stunnel.conf" ]] && ptssl="$(netstat -nplt |grep 'stunnel' | awk {'print $4'} |cut -d: -f2 |xargs)" || ptssl='3128'
            [[ -e "/etc/openvpn/server.conf" ]] && ptvpn="$(netstat -nplt |grep 'openvpn' |awk {'print $4'} |cut -d: -f2 |xargs)" || ptvpn='1194'
            DEBIAN_FRONTEND=noninteractive apt-get -y install sslh
            echo -e "#Modo autónomo\n\nRUN=yes\n\nDAEMON=/usr/sbin/sslh\n\nDAEMON_OPTS='--user sslh --listen 0.0.0.0:443 --ssh 127.0.0.1:22 --ssl 127.0.0.1:$ptssl --http 127.0.0.1:777 --openvpn 127.0.0.1:$ptvpn --timeout 5 --pidfile /var/run/sslh/sslh.pid'" > /etc/default/sslh
            /etc/init.d/sslh start && service sslh start
        }
        echo -e "\n\033[1;32mMENGINSTAL SSLH!\033[0m\n"
        fun_bar 'fun_instsslh'
        echo -e "\n\033[1;32mMULAI SSLH !\033[0m\n"
        fun_bar '/etc/init.d/sslh restart && service sslh restart'
        [[ $(netstat -nplt |grep -w 'sslh' | wc -l) != '0' ]] && echo -e "\n\033[1;32mINSTALADO COM SUCESSO !\033[0m" || echo -e "\n\033[1;31mERRO INESPERADO !\033[0m"
        sleep 3
        fun_conexao
     else
         echo -e "\n\033[1;31mKembali.."
         sleep 2
         fun_conexao
     fi
  } || {
    clear
    echo -e "\E[41;1;37m             HAPUS SSLH               \E[0m\n"
	echo -ne "\033[1;32mBENAR-BENAR INGIN MENGHAPUS SSLH \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read respo
    if [[ "$respo" = "s" ]]; then
	    fun_delsslh () {
	        /etc/init.d/sslh stop && service sslh stop
	        apt-get remove sslh -y
	        apt-get purge sslh -y
	     }
	    echo -e "\n\033[1;32mMENGHAPUS SSLH !\033[0m\n"
	    fun_bar 'fun_delsslh'
	    echo -e "\n\033[1;32mSUKSES DIHAPUS !\033[0m\n"
	    sleep 2
	    fun_conexao
    else
	     echo -e "\n\033[1;31mKembalio.."
         sleep 2
         fun_conexao
    fi
  }
}

x="ok"
fun_conexao () {
while true $x != "ok"
do
[[ ! -e '/home/sshplus' ]] && exit 0
clear
echo -e "\E[44;1;37m                MODE SAMBUNGAN                 \E[0m\n"
echo -e "\033[1;32mSERVICE: \033[1;33mOPENSSH \033[1;32mPORT: \033[1;37m$(grep 'Port' /etc/ssh/sshd_config|cut -d' ' -f2 |grep -v 'no' |xargs)" && sts6="\033[1;32m◉ "

[[ "$(netstat -nltp|grep 'sslh' |wc -l)" != '0' ]] && {
	echo -e "\033[1;32mSERVICE: \033[1;33mSSLH: \033[1;32mPORT: \033[1;37m$(netstat -nplt |grep 'sslh' |awk {'print $4'} |cut -d: -f2 |xargs)"
	sts7="\033[1;32m◉ "
} || {
	sts7="\033[1;31m○ "
}

[[ "$(netstat -nplt |grep 'openvpn' |wc -l)" != '0' ]] && {
	echo -e "\033[1;32mSERVICE: \033[1;33mOPENVPN: \033[1;32mPORT: \033[1;37m$(netstat -nplt |grep 'openvpn' |awk {'print $4'} |cut -d: -f2 |xargs)"
	sts5="\033[1;32m◉ "
} || {
	sts5="\033[1;31m○ "
}

[[ "$(netstat -nplt |grep 'python' |wc -l)" != '0' ]] && {
	echo -e "\033[1;32mSERVICE: \033[1;33mPROXY SOCKS \033[1;32mPORT: \033[1;37m$(netstat -nplt |grep 'python' | awk {'print $4'} |cut -d: -f2 |xargs)"
	sts4="\033[1;32m◉ "
} || {
	sts4="\033[1;31m○ "
}
[[ -e "/etc/stunnel/stunnel.conf" ]] && {
	echo -e "\033[1;32mSERVICE: \033[1;33mSSL TUNNEL \033[1;32mPORT: \033[1;37m$(netstat -nplt |grep 'stunnel' | awk {'print $4'} |cut -d: -f2 |xargs)"
	sts3="\033[1;32m◉ "
} || {
	sts3="\033[1;31m○ "
}
[[ "$(netstat -nltp|grep 'dropbear' |wc -l)" != '0' ]] && {
	echo -e "\033[1;32mSERVICE: \033[1;33mDROPBEAR \033[1;32mPORT: \033[1;37m$(netstat -nplt |grep 'dropbear' | awk -F ":" {'print $4'} | xargs)"
	sts2="\033[1;32m◉ "
} || {
	sts2="\033[1;31m○ "
}
[[ "$(netstat -nplt |grep 'squid'| wc -l)" != '0' ]] && {
	echo -e "\033[1;32mSERVICE: \033[1;33mSQUID \033[1;32mPORT: \033[1;37m$(netstat -nplt |grep 'squid' | awk -F ":" {'print $4'} | xargs)"
	sts1="\033[1;32m◉ "
} || {
	sts1="\033[1;31m○ "
}
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -e "\033[1;31m[\033[1;36m01\033[1;31m] \033[1;37m• \033[1;33mOPENSSH $sts6\033[1;31m
[\033[1;36m02\033[1;31m] \033[1;37m• \033[1;33mSQUID PROXY $sts1\033[1;31m
[\033[1;36m03\033[1;31m] \033[1;37m• \033[1;33mDROPBEAR $sts2\033[1;31m
[\033[1;36m04\033[1;31m] \033[1;37m• \033[1;33mOPENVPN $sts5\033[1;31m
[\033[1;36m05\033[1;31m] \033[1;37m• \033[1;33mPROXY SOCKS $sts4\033[1;31m
[\033[1;36m06\033[1;31m] \033[1;37m• \033[1;33mSSL TUNNEL $sts3\033[1;31m
[\033[1;36m07\033[1;31m] \033[1;37m• \033[1;33mSSLH MULTIPLEX $sts7\033[1;31m
[\033[1;36m08\033[1;31m] \033[1;37m• \033[1;33mKEMBALI \033[1;32m<\033[1;33m<\033[1;31m< \033[1;31m
[\033[1;36m00\033[1;31m] \033[1;37m• \033[1;33mKELUAR \033[1;32m<\033[1;33m<\033[1;31m< \033[0m"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
tput civis
echo -ne "\033[1;32mAPA YANG INGIN KAMU LAKUKAN \033[1;33m?\033[1;31m?\033[1;37m "; read x
tput cnorm
clear
case $x in
	1|01)
	fun_openssh
	;;
	2|02)
	fun_squid
	;;
	3|03)
	fun_drop
	;;
	4|04)
	fun_openvpn
	;;
	5|05)
	fun_socks
	;;
	6|06)
	inst_ssl
	;;
	7|07)
	fun_sslh
	;;
	8|08)
	menu
	;;
	0|00)
	echo -e "\033[1;31mKeluar...\033[0m"
	sleep 2
	clear
	exit;
	;;
	*)
	echo -e "\033[1;31mOpsi tidak valid !\033[0m"
	sleep 2
esac
done
}
fun_conexao
else
	rm -rf /bin/criarusuario /bin/expcleaner /bin/sshlimiter /bin/addhost /bin/listar /bin/sshmonitor /bin/ajuda /bin/menu /bin/OpenVPN /bin/userbackup /bin/tcpspeed /bin/badvpn /bin/otimizar /bin/speedtest /bin/trafego /bin/banner /bin/limit /bin/Usercreate /bin/senharoot /bin/reiniciarservicos /bin/reiniciarsistema /bin/attscript /bin/criarteste /bin/socks  /bin/DropBear /bin/alterarlimite /bin/alterarsenha /bin/remover /bin/detalhes /bin/mudardata /bin/botssh /bin/versao > /dev/null 2>&1
    rm -rf /etc/SSHPlus > /dev/null 2>&1
    clear
    exit 0
fi
