echo $TERM

echo "Primeiro stty"
stty -a

echo "Segundo stty com raw"
stty raw -echo
fg
reset
nc



