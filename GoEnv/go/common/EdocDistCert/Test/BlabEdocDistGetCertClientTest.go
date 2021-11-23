package main

import (
	blabClient "../Client"
	testClient "./TestConfig"
	"log"
)

// 전자문서 유통증명서 발급 테스트
func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	err := testClient.BlabTestClientInit()
	if err != nil {
		return
	}

	clientConfig := testClient.ClientConfig
	appRes, err := blabClient.PostEdocDistGetCert(clientConfig.Server.BaseUrl, clientConfig.Individual.EdocNum, clientConfig.Individual.Eaddr, clientConfig.Individual.Reason)
	if err != nil {
		log.Printf("err=%+v\n", err)
		return
	}

	log.Printf("appRes=%+v", appRes)
	log.Printf("appRes.Data=%+v", appRes.Data)
}
