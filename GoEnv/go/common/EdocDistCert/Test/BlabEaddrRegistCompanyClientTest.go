package main

import (
	blabClient "../Client"
	testClient "./TestConfig"
	"log"
)

func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)

	err := testClient.BlabTestClientInit()
	if err != nil {
		return
	}

	clientConfig := testClient.ClientConfig
	appRes, err := blabClient.PostEaddrRegistCompany(clientConfig.Server.BaseUrl, clientConfig.Company.Idn, clientConfig.Company.Eaddr, clientConfig.Company.Name,
		1, clientConfig.Company.RegDate, "../exampleFile/biz-doc.jpg", "../exampleFile/reg-doc.jpg")
	if err != nil {
		log.Printf("err=%+v\n", err)
		return
	}

	log.Printf("appRes=%+v", appRes)
	log.Printf("appRes.Data=%+v", appRes.Data)
}
