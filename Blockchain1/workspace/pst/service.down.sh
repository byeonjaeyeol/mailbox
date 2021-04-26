 #rm -f ./dcp-*.yaml 
 #cp ./node1/*.yaml ./ 

 docker-compose  -f dcp-ca.yaml -f dcp-orderer.yaml -f dcp-peers.yaml -f mon-nodeexporter.yaml down --volumes --remove-orphans 
 #rm -rf /data/storage/*
