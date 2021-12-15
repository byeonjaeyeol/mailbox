package main

import (
	blabClient "../Client"
	testClient "./TestConfig"
	"log"
)

// 전자문서 유통증명서 발급 후 게이트웨이에 저장 테스트
// 게이트웨이에서 저장하고 저장된 파일을 다운로드하려면 GetEdocDistDownloadCert를 사용해야 함
// go 웹 서버에서의 사용 예제는 BlabEdocDistSaveAndDownloadCertWebTest.go를 참조
func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	err := testClient.BlabTestClientInit()
	if err != nil {
		return
	}

	clientConfig := testClient.ClientConfig
	appRes, err := blabClient.PostEdocDistSaveCert(clientConfig.Server.BaseUrl, clientConfig.Individual.EdocNum, clientConfig.Individual.Eaddr, clientConfig.Individual.Reason)
	if err != nil {
		log.Printf("err=%+v\n", err)
		return
	}

	log.Printf("appRes=%+v", appRes)
	log.Printf("appRes.Data=%+v", appRes.Data)
}
