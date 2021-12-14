package main

import (
	blabClient "../Client"
	blabModel "../Model/Blab"
	testClient "./TestConfig"
	"log"
)

// 전자문서 유통증명서 다운로드 테스트
// GetEdocDistSaveCert를 사용하여 파일 정보를 먼저 게이트웨이에 지정해야 함
func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	err := testClient.BlabTestClientInit()
	if err != nil {
		return
	}

	clientConfig := testClient.ClientConfig
	appRes, err := blabClient.GetEdocDistDownloadCert(clientConfig.Server.BaseUrl, clientConfig.Individual.CertNum, clientConfig.Individual.CertFilename)
	if err != nil {
		log.Printf("err=%+v\n", err)
		return
	}

	log.Printf("appRes=%+v", appRes)
	if fileDownloadResponse, ok := appRes.Data.(*blabModel.BlabFileDownloadResponse); ok {
		log.Printf("resultCode=%+v, errCode=%+v, errMsg=%+v, len(fileBytes)=%+v\n",
			fileDownloadResponse.ResultCode,
			fileDownloadResponse.ErrCode,
			fileDownloadResponse.ErrMsg,
			len(fileDownloadResponse.FileBytes))
	} else {
		log.Printf("파일 다운로드 응답이 아님")
	}
	/*
		w.WriteHeader(http.StatusOK)
		// w.Header().Set("Content-Type", "application/octet-stream") // 무조건 다운로드하게 하려면 application/octet-stream을 사용
		w.Header().Set("Content-Type", "application/pdf")	// pdf를 브라우저에서 확인 후 pdf viewer에서 다운로드하게 하려면 application/pdf 사용
		w.Write(appRes.Data.FileBytes)
	*/
}
