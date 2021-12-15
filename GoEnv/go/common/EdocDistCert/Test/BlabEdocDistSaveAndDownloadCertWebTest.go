package main

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
	saveRes, err := blabClient.PostEdocDistSaveCert(clientConfig.Server.BaseUrl, clientConfig.Individual.EdocNum, clientConfig.Individual.Eaddr, clientConfig.Individual.Reason)
	if err != nil {
		log.Printf("err=%+v\n", err)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}

	log.Printf("saveRes=%+v", saveRes)
	log.Printf("saveRes.Data=%+v", saveRes.Data)

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
			w.Header().Set("Content-Type", "application/pdf")
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
