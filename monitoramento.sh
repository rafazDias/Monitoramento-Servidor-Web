#!/usr/bin/env bash
#
# monitoramento.sh - Monitora o status do serivdor Nginx
#
# Autor:      Rafael Dias
# Manutenção: Rafael Dias
#
# ------------------------------------------------------------------------ #
#  Ira monitorar o servidor Nginx e toda vez que estiver offline ira enviar
#  uma mensagem no discord
#  será automaticamente ativado a cada 1 minuto
#
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.2.21
# ------------------------------- VARIAVEIS ----------------------------------------- #
   LOG="/var/log/monitoramento.log" #Insira o caminho para armazenamento dos LOGS
   IP="$(hostname -I)" #INSIRA O IP DO WEBSERVER QUE DESEJA MONITORAR
   URL_WEBHOOK="https://discord.com/api/webhooks/1354255292874887228/ljKqMZgq5rYAY3TK3hO1Qd_FqTMKAM2jUaPud6PDvvMSSUHIGPmpsYGivr5SA6Qd_sCK" # INSIRA O URL DO WEBHOOK AQUI 
   MENSAGEM='{"username": "Hunting Nginx", "content": ":no_entry_sign: SERVIDOR ESTÁ OFFLINE \n\n:tools:Estamos em manutenção!"}' #INSIRA A MENSAGEM AQUI
#   
# ------------------------------- FUNÇÕES ----------------------------------------- #
Monitoria () {
    local HTTP_REQUEST="$(curl -s -o /dev/null -w "%{http_code}" $IP)"


    if [ "$HTTP_REQUEST" = "200" ]
    then
        echo "SERVIDOR ESTA ONLINE" >> $LOG
    else
        echo "SERVIDOR ESTÁ OFFLINE" >> $LOG
        curl \
        -H "Content-Type: application/json" \
        -d "$MENSAGEM"                      \
        $URL_WEBHOOK
    fi
    
}

# ------------------------------------------------------------------------ #
# ------------------------------- EXECUÇÃO ----------------------------------------- #
Monitoria
# ------------------------------------------------------------------------ #