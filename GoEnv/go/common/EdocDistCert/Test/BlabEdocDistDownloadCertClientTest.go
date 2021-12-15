package main

import (
	blabClient "../Client"
	blabModel "../Model/Blab"
	testClient "./TestConfig"
	"log"
)

// 전자문서 유통증명서 게이트웨이에 저장된 것 다운로드 테스트
// PostEdocDistSaveCert를 사용하여 파일 정보를 먼저 게이트웨이에 지정해야 함
// go 웹 서버에서의 사용 예제는 BlabEdocDistSaveAndDownloadCertWebTest.go를 참조
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
		/*
			실제 사용 예제는 BlabEdocDistSaveAndDownloadWebTest.go를 참조
			// * 브라우저에서 미리보기만 할 때(다운로드는 미리보기에서 사용자가 직접 진행)
			// Content-Disposition을 없애고 application/pdf로 지정
			// * 브라우저에서 미리보기 없이 자동으로 다운로드하게 할 때
			//   1. Content-Disposition이 있으면 Content-Disposition의 filename으로 다운로드
			//   2. Content-Disposition 없이 application/octet-stream만 지정할 때에는 URL을 파일명으로 다운로드
			w.Header().Set("Content-Type", "application/pdf")
			// w.Header().Set("Content-Type", "application/octet-stream")
			w.Header().Set("Content-Disposition", fmt.Sprintf("attachment; filename=\"%s\"", certRes.Filename))
			w.Header().Set("Content-Length", fmt.Sprintf("%d", len(fileDownloadResponse.FileBytes)))
			// WriteHeader하기 전에 Header 데이터를 지정해야 함
			w.WriteHeader(http.StatusOK)
			w.Write(fileDownloadResponse.FileBytes)
		*/
		return
	}

	log.Printf("파일 다운로드 응답이 아님")

}
