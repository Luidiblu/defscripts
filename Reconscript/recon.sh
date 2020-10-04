resultado = "/root/Recon"
ferramentas = "/root/Tools"

morre() {
    printf '%s\n' "$1" >&2
    exit 1
}

noob() {
  banner
  echo -e "Tipo assim, irmão: ./recon.sh -d dominio.com -r -s
      -d  | --domain      (obrigatorio) : Dominio, uai, tu é burro?
      -r  | --recon       (se quiser) : Procura por sub dominios
      -s  | --scan        (se quiser) : Scaneia o dominio especifico
      -c  | --amassconfig (se quiser) : Melhores resultados
      -rp | --resultspath (se quiser) : Define a pasta de output
  "
}

banner(){
  echo -e "
   ____    ___  ____  ______   ____  ______    ___    __  __ __
  |    \  /   \|    ||      | /    ||      |  /  _]  /  ]|  |  |
  |  o  )|     ||  | |      ||  o  ||      | /  [_  /  / |  |  |
  |     ||  O  ||  | |_|  |_||     ||_|  |_||    _]/  /  |  _  |
  |  O  ||     ||  |   |  |  |  _  |  |  |  |   [_/   \_ |  |  |
  |     ||     ||  |   |  |  |  |  |  |  |  |     \     ||  |  |
  |_____| \___/|____|  |__|  |__|__|  |__|  |_____|\____||__|__|
 "
}

scan() {
  echo -e "Scan of \e[31m$1\e[0m ta rolando"
  mkdir -p $ResultsPath/$domain/$(date +%F)/$1

  ## Nuclei
	echo -e ">> \e[36mNuclei\e[0m ta rolando"
	echo -e $1 | httprobe -p http:81 -p https:81 -p https:8443 -p http:8080 -p https:8080 > $ResultsPath/$domain/$(date +%F)/$1/httprobe.txt
  nuclei -l $ResultsPath/$domain/$(date +%F)/$1/httprobe.txt -t $ToolsPath/nuclei-templates/ -o $ResultsPath/$domain/$(date +%F)/$1/nuclei.txt > /dev/null 2>&1

  ## GAU
  echo -e ">> \e[36mGAU\e[0m ta rolando"
  gau $1 >> $ResultsPath/$domain/$(date +%F)/$1/gau.txt

  ## Hawkraler
	echo -e ">> \e[36mHakrawler\e[0m ta rolando"
	echo -e $1 | hakrawler -forms -js -linkfinder -plain -robots -sitemap -usewayback -outdir $ResultsPath/$domain/$(date +%F)/$1/hakrawler | kxss >> $ResultsPath/$domain/$(date +%F)/$1/kxss.txt

  ## ParamSpider
	echo -e ">> \e[36mParamSpider\e[0m ta rolando"
	cd $ToolsPath/ParamSpider/
	python3 paramspider.py --domain $1 --exclude woff,css,js,png,svg,jpg -o paramspider.txt > /dev/null 2>&1

  if [ -s $ToolsPath/ParamSpider/output/paramspider.txt ]
  then
    	mv ./output/paramspider.txt $ResultsPath/$domain/$(date +%F)/$1/

      ## GF
      echo -e ">> \e[36mGF\e[0m ta rolando"
      mkdir $ResultsPath/$domain/$(date +%F)/$1/GF

      gf xss $ResultsPath/$domain/$(date +%F)/$1/paramspider.txt >> $ResultsPath/$domain/$(date +%F)/$1/GF/xss.txt
      gf potential $ResultsPath/$domain/$(date +%F)/$1/paramspider.txt >> $ResultsPath/$domain/$(date +%F)/$1/GF/potential.txt
      gf debug_logic $ResultsPath/$domain/$(date +%F)/$1/paramspider.txt >> $ResultsPath/$domain/$(date +%F)/$1/GF/debug_logic.txt
      gf idor $ResultsPath/$domain/$(date +%F)/$1/paramspider.txt >> $ResultsPath/$domain/$(date +%F)/$1/GF/idor.txt
      gf lfi $ResultsPath/$domain/$(date +%F)/$1/paramspider.txt >> $ResultsPath/$domain/$(date +%F)/$1/GF/lfi.txt
      gf rce $ResultsPath/$domain/$(date +%F)/$1/paramspider.txt >> $ResultsPath/$domain/$(date +%F)/$1/GF/rce.txt
      gf redirect $ResultsPath/$domain/$(date +%F)/$1/paramspider.txt >> $ResultsPath/$domain/$(date +%F)/$1/GF/redirect.txt
      gf sqli $ResultsPath/$domain/$(date +%F)/$1/paramspider.txt >> $ResultsPath/$domain/$(date +%F)/$1/GF/sqli.txt
      gf ssrf $ResultsPath/$domain/$(date +%F)/$1/paramspider.txt >> $ResultsPath/$domain/$(date +%F)/$1/GF/ssrf.txt
      gf ssti $ResultsPath/$domain/$(date +%F)/$1/paramspider.txt >> $ResultsPath/$domain/$(date +%F)/$1/GF/ssti.txt
  fi

  ## SubDomainizer
  echo -e ">> \e[36mSubDomainizer\e[0m ta rolando"
  python3 $ToolsPath/SubDomainizer/SubDomainizer.py -u $1 -o $ResultsPath/$domain/$(date +%F)/$1/SubDomainizer.txt > /dev/null 2>&1

  ## RM ParamSpider output
  if [ -s $ToolsPath/ParamSpider/output/paramspider.txt ]
  then
    rm $ToolsPath/ParamSpider/output/paramspider.txt
  fi
}

main() {
  banner

  if [ -v recon ]
  then
    echo -e "Recon is in \e[31mprogress\e[0m, vai demorar"


    echo -e ">> \e[36mAmass\e[0m ta rolando"


    mkdir -p $ResultsPath/$domain/Amass
    wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/deepmagic.com-prefixes-top50000.txt -P $ResultsPath/$domain/ > /dev/null 2>&1

    if [ -z "$ac" ]
    then
      amass enum -active -o $ResultsPath/$domain/$(date +%F)/domains_tmp.txt -d $domain -brute -w $ResultsPath/$domain/deepmagic.com-prefixes-top50000.txt -dir $ResultsPath/$domain/Amass > /dev/null 2>&1
    else
      amass enum -active -o $ResultsPath/$domain/$(date +%F)/domains_tmp.txt -d $domain -brute -w $ResultsPath/$domain/deepmagic.com-prefixes-top50000.txt -config $ac -dir $ResultsPath/$domain/Amass > /dev/null 2>&1
    fi

    echo -e ">> \e[36mGithub-Subdomains.py\e[0m ta rolando"
    python3 /root/Tools/Github-Subdomains/github-subdomains.py -d $domain >> $ResultsPath/$domain/$(date +%F)/domains_tmp.txt

    cat $ResultsPath/$domain/$(date +%F)/domains_tmp.txt | sort -u > $ResultsPath/$domain/$(date +%F)/domains.txt
    rm $ResultsPath/$domain/$(date +%F)/domains_tmp.txt

    echo -e ">> \e[36mAquatone\e[0m ta rolando"
    mkdir $ResultsPath/$domain/$(date +%F)/Aquatone
    cd $ResultsPath/$domain/$(date +%F)/Aquatone
    cat ../domains.txt | aquatone -chrome-path /snap/bin/chromium -ports xlarge > /dev/null 2>&1


    rm $ResultsPath/$domain/deepmagic.com-prefixes-top50000.txt
  fi

  if [ -v scan ]
  then
    if [ -v recon ]
    then
      while read line; do
        scan $line
      done < $ResultsPath/$domain/$(date +%F)/domains.txt
    else
      scan $domain
    fi
  fi

  echo -e "=========== \e[32mfinish\e[0m ==========="
}

while :; do
    case $1 in
        -h|-\?|--help)
            help
            exit
            ;;
        -d|--domain)
            if [ "$2" ]; then
                domain=$2
                shift
            else
                die 'DEU RUIM: "--domain" eh obrigatorio.'
            fi
            ;;
        --domain=)
            die 'DEU RUIM: "--domain" n pode ser nulo.'
            ;;
        -c|--amassconfig)
            if [ "$2" ]; then
                ac=$2
                shift
            fi
            ;;
        -rp|--resultspath)
            if [ "$2" ]; then
                ResultsPath=$2
                shift
            fi
            ;;
        -s|--scan)
            scan=true
            ;;
        -r|--recon)
            recon=true
            ;;
        --)
            shift
            break
            ;;
        -?*)
            printf 'AVISO: Sahporra n existe (ignored): %s\n' "$1" >&2
            ;;
        *)
            break
    esac

    shift
done

if [ -z "$domain" ]
then
  help
  die 'DA UM SALVE AQUI: "--domain" n pode ser nulo.'
else
  if [ ! -d "$ResultsPath/$domain" ];then
    mkdir -p $ResultsPath/$domain/$(date +%F)
  fi
  main
fi
