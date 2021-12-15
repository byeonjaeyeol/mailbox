package main

// BlabEdocDistSaveAndDownloadCertWebTest
// 전자문서 유통증명서 발급 및 게이트웨이 저장, 유통증명서 다운로드 웹 서버에서 처리하는 예제
// go run BlabDistSaveAndDownloadCertWebTsst.go를 실행한 뒤
// 브라우저에서 http://localhost:2345/saveAndDownload에 접속하면 유통증명서 pdf가 표시됨

import (
	blabClient "../Client"
	blabModel "../Model/Blab"
	testClient "./TestConfig"
	"errors"
	"fmt"
	"log"
	"net/http"
)

func blabEdocDictSsaveAndDownloadCert(w http.ResponseWriter, req *http.Request) {
	err := testClient.BlabTestClientInit()
	if err != nil {
		return
	}

	clientConfig := testClient.ClientConfig
	// KISA에서 유통증명서를 발급 받아 게이트웨이에 저장
	// clientConfig의 Eaddr, EdocNum, Reason을 유호한 값으로 지정한 뒤 호출해야 함
	saveRes, err := blabClient.PostEdocDistSaveCert(clientConfig.Server.BaseUrl, clientConfig.Individual.EdocNum, clientConfig.Individual.Eaddr, clientConfig.Individual.Reason)
	if err != nil {
		log.Printf("err=%+v\n", err)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}

	log.Printf("saveRes=%+v", saveRes)
	log.Printf("saveRes.Data=%+v", saveRes.Data)

	// 게이트웨이에 저장된 유통증명서를 브라우저 또는 앱 단말로 다운로드
	// 게이트웨이에 저장된 유통증멍서 바이너리를 브라으저 또는 앱으로 전달하는 기능이며
	// 브라우저나 앱에서는 이 바아너리를 단말기에 저장하면 됨
	if certRes, ok := saveRes.Data.(*blabModel.BlabEdocDistGetCertResponse); ok {
		downloadRes, err := blabClient.GetEdocDistDownloadCert(clientConfig.Server.BaseUrl, certRes.CertNum, certRes.Filename)
		if err != nil {
			log.Printf("err=%+v\n", err)
			w.WriteHeader(http.StatusInternalServerError)
			w.Write([]byte(err.Error()))
			return
		}

		log.Printf("downloadRes=%+v", downloadRes)
		if fileDownloadResponse, ok := downloadRes.Data.(*blabModel.BlabFileDownloadResponse); ok {
			log.Printf("resultCode=%+v, errCode=%+v, errMsg=%+v, len(fileBytes)=%+v\n",
				fileDownloadResponse.ResultCode, fileDownloadResponse.ErrCode, fileDownloadResponse.ErrMsg, len(fileDownloadResponse.FileBytes))
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
			return
		}
	}

	err = errors.New("파일 다운로드 응답이 아님")
	log.Printf("err=%+v\n", err)
	w.WriteHeader(http.StatusInternalServerError)
	w.Write([]byte(err.Error()))
}

// 전자문서 유통증명서 게이트웨이에서 저장 후 다운로드하는 웹 테스트
func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	http.HandleFunc("/saveAndDownload", blabEdocDictSsaveAndDownloadCert)
	http.ListenAndServe(":2345", nil)
}
