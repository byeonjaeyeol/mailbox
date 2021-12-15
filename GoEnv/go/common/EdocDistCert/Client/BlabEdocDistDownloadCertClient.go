package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

// GetEdocDistDownloadCert 유통증명서 파일 다운로드
// 이 기능을 사용하기 위해서는 PostEdocDistSaveCert를 먼저 실행해야 하며
// PostEdocDistSaveCert의 결과 중 certNum, fileName(-> certFilename)을 파라미터로 사용함
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- certNum string : 유통증명서 일련번호
//	- certFilename string : 유통증명서 파일명
// Returns
//  - *blabModel.BlabResponse: Data는 없음, 설공일 경우에는 유통증명서 pdf의 바이너리 데이터
//  - error
func GetEdocDistDownloadCert(baseUrl string, certNum string, certFilename string) (*blabModel.BlabResponse, error) {
	queryParam := blabModel.BlabEdocDistDownloadCertRequest{CertNum: certNum, CertFilename: certFilename}
	url := baseUrl + "/api/cert/download"
	appRes, err := ClientCall(http.MethodGet, url, queryParam, nil, &blabModel.BlabFileDownloadResponse{})
	return appRes, err
}
