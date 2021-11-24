package main

import (
	blabClient "../Client"
	testClient "./TestConfig"
	"log"
)

// 법인 공인전자주소 소유자정보 수정 테스트(법인)
func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	err := testClient.BlabTestClientInit()
	if err != nil {
		return
	}

	clientConfig := testClient.ClientConfig
	appRes, err := blabClient.PostEaddrUpdateUserCompany(clientConfig.Server.BaseUrl, clientConfig.Company.Eaddr, clientConfig.Company.Name, clientConfig.Company.UpdDate,
		"exampleFile/biz-doc.jpg", "exampleFile/reg-doc.jpg")
	if err != nil {
		log.Printf("err=%+v\n", err)
		return
	}

	log.Printf("appRes=%+v", appRes)
	log.Printf("appRes.Data=%+v", appRes.Data)
}
