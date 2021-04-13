dirs=(  
        API-WAS1/data/storage
        DB-Service01/data/analyzer/backup
        DB-Service01/data/analyzer/logs
        DB-Service01/data/analyzer/result
        DB-Service01/data/analyzer/temp
        DB-Service01/data/sender/backup
        DB-Service01/data/sender/logs
        DB-Service01/mariadb
        External01/data/11001/60002
        Service03/log01
        Service03/node01
        Service04/log02
        Service04/node02
        Service04/data/POSA/ESB/receive/WID04039401385
        Service04/data/POSA/ESB/receive_work
        Service04/data/POSA/ESB/send
        Service04/data/POSA/ESB/send_work
        Service04/data/tilon/IljariAgent/backup
        Service04/data/tilon/IljariAgent/logs
        Service04/data/tilon/IljariAgent/option
        Service04/data/tilon/IljariAgent/result
        Service04/data/tilon/sender/backup
        Service04/data/tilon/sender/data
        Service04/data/tilon/sender/logs
     )

for dir in "${dirs[@]}"; do
    if [ ! -d $dir ]; then
        mkdir -p $dir
    fi
done

