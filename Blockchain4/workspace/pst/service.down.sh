 #rm -f ./dcp-*.yaml 
 #cp ./node4/*.yaml ./ 

 docker-compose  -f dcp-ca.yaml -f dcp-peers.yaml down --volumes --remove-orphans 
 #rm -rf /data/storage/*