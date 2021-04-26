 #rm -f ./dcp-*.yaml 
 #cp ./node3/*.yaml ./ 

 docker-compose  -f dcp-orderer.yaml -f dcp-peers.yaml up -d 