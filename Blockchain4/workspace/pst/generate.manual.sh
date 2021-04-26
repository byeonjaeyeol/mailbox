sh service.down.sh
rm -rf ./channel-artifacts
rm -rf ./crypto-config
rm -rf ./wallet
rm -rf /git/storage/*
mkdir  ./channel-artifacts
mkdir ./wallet

cryptogen generate --config=./crypto-config.yaml --output=./crypto-config
configtxgen -profile KtbcpOrgsOrdererGenesis -channelID=pst-sys-channel -outputBlock ./channel-artifacts/genesis.block
configtxgen -profile KtbcpOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID pstchannel1
#configtxgen -profile KtbcpOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/__MSPID__anchors.tx -channelID pstchannel1 -asOrg __MSPID__
configtxgen -profile KtbcpOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/anpu_pstchannel1_org1Msp_anchors.tx -channelID pstchannel1 -asOrg org1Msp 
configtxgen -profile KtbcpOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/anpu_pstchannel1_org2Msp_anchors.tx -channelID pstchannel1 -asOrg org2Msp 
configtxgen -profile KtbcpOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/anpu_pstchannel1_org3Msp_anchors.tx -channelID pstchannel1 -asOrg org3Msp 
