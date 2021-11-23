package main

import (
	blabClient "../Client"
	testClient "./TestConfig"
	"log"
)

// 공인전자주소 조회 테스트(개인)
func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	err := testClient.BlabTestClientInit()
	if err != nil {
		return
	}

	clientConfig := testClient.ClientConfig
	appRes, err := blabClient.GetEaddr(clientConfig.Server.BaseUrl, clientConfig.Individual.Idn, clientConfig.Auth.PlatformId)
	if err != nil {
		log.Printf("err=%+v\n", err)
		return
	}

	log.Printf("appRes=%+v", appRes)
	log.Printf("appRes.Data=%+v", appRes.Data)
}
