package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

// GetEdocDistDownloadCert 유통증명서 파일 다운로드
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- idn string : 이용자 고유번호
//	- platformId string : 조회대상 중계자플랫폼 ID(타 중계자의 플랫폼이 보유한 공인전자주소 조회시에만 사용)
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabEaddrGetResponse
//  - error
func GetEdocDistDownloadCert(baseUrl string, certNum string, certFileName string) (*blabModel.BlabResponse, error) {
	queryParam := blabModel.BlabEdocDistDownloadCertRequest{CertNum: certNum, CertFilename: certFileName}
	url := baseUrl + "/api/cert/download"
	appRes, err := ClientCall(http.MethodGet, url, queryParam, nil, &blabModel.BlabFileDownloadResponse{})
	return appRes, err
}
