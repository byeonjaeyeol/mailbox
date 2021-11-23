package main

import (
	blabClient "../../../common/EdocDistCert/Client"
	testClient "./TestConfig"
	"log"
)

// 공인전자주소 탈퇴 테스트(법인)
func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	err := testClient.BlabTestClientInit()
	if err != nil {
		return
	}

	clientConfig := testClient.ClientConfig
	appRes, err := blabClient.PatchEddrCancel(clientConfig.Server.BaseUrl, clientConfig.Company.Eaddr, clientConfig.Company.EaddrDelDate)
	if err != nil {
		log.Printf("err=%+v\n", err)
		return
	}

	log.Printf("appRes=%+v", appRes)
	log.Printf("appRes.Data=%+v", appRes.Data)
}
