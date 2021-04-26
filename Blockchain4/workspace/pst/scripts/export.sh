rm -rf tar/
mkdir tar/
docker save -o  tar/fabric-tools-1.4.0.tar	0a44f4261a55
docker save -o  tar/fabric-ccenv-1.4.0.tar	5b31d55f5f3a
docker save -o  tar/fabric-orderer-1.4.0.tar	54f372205580
docker save -o  tar/fabric-peer-1.4.0.tar	304fac59b501
docker save -o  tar/fabric-ca-1.4.0.tar		1a804ab74f58
docker save -o  tar/fabric-zookeeper-0.4.14.tar	d36da0db87a4
docker save -o  tar/fabric-kafka-0.4.14.tar	a3b095201c66
docker save -o  tar/fabric-couchdb-0.4.14.tar	f14f97292b4c
docker save -o  tar/fabric-baseos-0.4.14.tar	75f5fb1a0e0c
