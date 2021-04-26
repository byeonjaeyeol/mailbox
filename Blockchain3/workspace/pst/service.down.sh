 #rm -f ./dcp-*.yaml 
 #cp ./node3/*.yaml ./ 

 docker-compose  -f dcp-orderer.yaml -f dcp-peers.yaml down --volumes --remove-orphans 
 #rm -rf /data/storage/*