package main

import (
	blabClient "../Client"
	testClient "./TestConfig"
	"log"
)

// 공인전자주소 탈퇴 테스트(개인)
func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	err := testClient.BlabTestClientInit()
	if err != nil {
		return
	}

	clientConfig := testClient.ClientConfig
	appRes, err := blabClient.PatchEddrCancel(clientConfig.Server.BaseUrl, clientConfig.Individual.Eaddr, clientConfig.Individual.EaddrDelDate)
	if err != nil {
		log.Printf("err=%+v\n", err)
		return
	}

	log.Printf("appRes=%+v", appRes)
	log.Printf("appRes.Data=%+v", appRes.Data)
}
