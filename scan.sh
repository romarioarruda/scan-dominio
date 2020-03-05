#!/bin/bash

ip () {
    ping -c1 $site | sed -n '2p' | grep -Eo 'from\s(\d+.\d+.\d+.\d{2})' >> scaneado.txt
    if [ $? -eq 0 ];then
        echo 'IP armazenado.'
    fi
}

owner_id () {
    whois $site | grep -Eo 'ownerid:\s+(\d+.\d+.\d+\-\d+)|ownerid:\s+(\d+.\d+.\d+\/\d+\-\d+)' >> scaneado.txt
    if [ $? -eq 0 ];then
        echo 'Owner id armazenado.'
    fi
}

owner_mail () {
    whois $site | grep -Eo 'e-mail:\s(.*)' >> scaneado.txt
    if [ $? -eq 0 ];then
        echo 'Owner e-mail armazenado.'
    fi
}

owner () {
    whois $site | grep -Eo 'owner:\s+(.*)' >> scaneado.txt
    if [ $? -eq 0 ];then
        echo 'Owner armazenado.'
        echo '==============================' >> scaneado.txt
    fi
}

owner_data () {
    echo 'Varrendo informações...'
    ip
    owner_id
    owner_mail
    owner
}

redirect () {
    wget -bp $site
    sleep 3
    grep -Eo 'href="[^>]+"' $site/index.* | cut -d '\"' -f2 | grep -E 'https?'
}

while true;do
    echo "Digite um site"
    read site
    echo " "
    echo "Digite 1 pra descobrir dados do alvo, como ip, email, nome."
    echo "Digite 2 pra listar os redirecionamentos."
    read opcao

    case $opcao in
        1) owner_data
            ;;
        2) redirect
            ;;
        *) echo "Consulta inválida."
            ;;
    esac

done
exit