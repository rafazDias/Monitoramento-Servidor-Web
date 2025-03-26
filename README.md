## MONITORAMENTO DE SERVIDOR WEB

1-CRIAR UMA VPC

2-LANÇAR A EC2 e INSTALAR O NGINX

3-SCRIPT DE MONITORAMENTO

4-TESTES


## CRIANDO SUA VPC

-Clique na barra de buscas AWS e digite VPC. Agora no menu de inicial da VPC selecione "Suas VPCs"(Your VPCs)
![VPC-1](https://github.com/user-attachments/assets/59c40092-bae1-496e-a959-51b4256b08f6)
-Clique me "Suas VPCs"

-Clique em "CRIAR VPC"
![MENU CRIAR VPC](https://github.com/user-attachments/assets/777e6077-3078-428d-a0b4-646e1bc6359d)

-Coloque as seguintes configurações:
![CRIANDO VPC](https://github.com/user-attachments/assets/c72572ba-08ab-450e-837b-00ac1c1cfe75)

![CRIANDO VPC2](https://github.com/user-attachments/assets/80b9a42c-ad67-4645-a880-17136ab85a08)


# LANÇANDO A EC2

Digite EC2 na barra de busca
![Captura de tela de 2025-03-25 19-43-46](https://github.com/user-attachments/assets/3ca06712-b267-40ec-a706-e3082db8a801)

-Clique em Executar instancias

-Coloque uma distribuição Linux
![CRIANDOEC2](https://github.com/user-attachments/assets/9e72b971-81b3-41f9-9560-78e0d5d15210)
![PARDECHAVES](https://github.com/user-attachments/assets/95e1c162-ecb8-46ad-9bd8-8e9d639b74e9)

-Crie seu Par de chaves
![Captura de tela de 2025-03-25 19-49-56](https://github.com/user-attachments/assets/fd270ecd-92c2-40ea-9221-92778d492e0e)

-Nas configurações de rede,selecione a VPC que criamos, atribuindo a sub-rede publica para podermos nos conectar a maquina.
![CONFIGDEREDE](https://github.com/user-attachments/assets/410a8049-1ed8-4ecb-b63a-4a7541f00b6e)

-Nos grupos de segurança,habilite o atribuir IP publico automaticamente e coloque o SSH para seu IP e ative o HTTP para qualquer lugar 
![REGRASDESEGURANÇA](https://github.com/user-attachments/assets/57d4f9a1-c7d4-4239-abab-ee0460d213f2)

-Execute a instancia

-Conectando a EC2 via SSH

    sudo chmod 400 minha_chave.pem
    ssh -i minha_chave.pem ubuntu@IP_DA_INSTANCIA

# -INSTALANDO NGINX

    sudo apt update
    sudo apt-get install nginx

-Edite o HTML do Nginx:

    cd /var/www/html

-remova o arquivo do diretório atual e crie o arquivo index.html ou edite o arquivo que está presente na pasta

    nano index.html

-insira o seu codigo HTML

# -Fazendo o NGINX se auto-reiniciar quando parar

Edite o arquivo nginx.service usando:

    sudo nano /usr/lib/systemd/system/nginx.service

-Adicione as seguintes configurações:

    Restart=on-failure
    RestartSec=5s
-Execute os seguintes comandos para registrar as modificações

    sudo systemctl daemon-reload
    sudo systemctl nginx reload

# -Criando Webhook para o discord

-Selecione um servidor do discord que tenha privilégios de administrador 

-Abra as configurações do servidor 
![CONFIGSERVERWEBHOOK](https://github.com/user-attachments/assets/1e1d4971-20b6-4e28-bf2d-4879ffff089d)

-Clique em integrações e em Webhook
![MENUINTEGRAÇÕESFDISCORD](https://github.com/user-attachments/assets/1e3cce73-a4c8-4e72-8ec8-b904a2b265fd)

-Clique em Novo Webhook e copie a URL
![CRIANDOWEBHOOK](https://github.com/user-attachments/assets/f2a0d530-2b50-416a-942e-d268d971ce1a)

# SCRIPT DE MONITORAMENTO

-Crie um arquivo ".sh" e insira o seguinte script:

    LOG="/var/log/monitoramento.log"  #Insira o caminho para armazenamento dos LOGS
    
    IP="$(hostname  -I)"  #INSIRA O IP DO WEBSERVER QUE DESEJA MONITORAR
    
    URL_WEBHOOK="https://discord.com/api/webhooks/"  # INSIRA O URL DO WEBHOOK AQUI
    
    MENSAGEM='{"username": "user", "content": "message"}'  #INSIRA A MENSAGEM AQUI
    Monitoria () {
	    local  HTTP_REQUEST="$(curl  -s  -o /dev/null -w "%{http_code}" $IP)"
	    if [ "$HTTP_REQUEST"  =  "200" ]
	    then
		    echo  "SERVIDOR ESTA ONLINE"  >>  $LOG
	    else
		    echo  "SERVIDOR ESTÁ OFFLINE"  >>  $LOG
		    curl  \
		    -H  "Content-Type: application/json"  \
		    -d  "$MENSAGEM"  \
		    $URL_WEBHOOK
	    fi
    }
    #-------------------EXEC---------------------------------#
    Monitoria

## Automatização do Script para executar de 1 em 1 minuto

-Crie um serviço com o systemd para realizar a automatização

    sudo nano /etc/systemd/system/meu_script.service

-Adicione as linhas: 

     [Unit]
     Description=Executa o script de monitoramento
    
     [Service]
     ExecStart=/home/usuario/script/meu_script.sh
-Crie um serviço de timer:

    sudo nano /etc/systemd/system/meu.script.timer
-Adicione as seguintes configurações:

    [Unit]
     Description=Timer para o script ser executado
    
     [Timer]
     OnBootSec=1min
     OnUnitActiveSec=1min
     AccuracySec=1s
     Unit=monitoramento.service
    
     [Install]
     WantedBy=timers.target

-Execute os seguintes comandos para registrar os serviços acima

    sudo systemctl daemon-reload
    sudo systemctl enable meu_script.timer
    sudo systemctl start meu_script.timer

# -TESTES
-Verifique se o servidor está funcionando

-Insira o IP da instancia no navegador
![Captura de tela de 2025-03-25 22-04-03](https://github.com/user-attachments/assets/c55cd366-01bf-42ca-85e8-cd9d387a3786)


-Tente parar o serviço e veja se ele reinicie automaticamente:

    sudo pkill -9 nginx
-Teste a notificação do Discord

![Captura de tela de 2025-03-25 22-20-03](https://github.com/user-attachments/assets/9017edf1-2272-475e-9f47-cdbf83a4d37c)

