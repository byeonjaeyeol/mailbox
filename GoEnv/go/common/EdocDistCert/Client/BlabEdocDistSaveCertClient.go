package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

// PostEdocDistSaveCert 전자문서 유통증명서 게이트웨이에 저장
// 이 함수를 실행 후 실제 유통증명서를 다운로드하려면 이 함수 응답의 certNum, fileName(-> certFilename)을 파라리터로 GetEdocDistDownoadCer 함수를 실행해야 함
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- edocNum string : 전자문서번호
//	- eaddr string : 유통증명서 요청 이용자 공인전자주소
//	- reason string : 유통증명서 발급요청 사유
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabEdocDistGetCertResponse
//  - error
func PostEdocDistSaveCert(baseUrl string, edocNum string, eaddr string, reason string) (*blabModel.BlabResponse, error) {
	bodyData := blabModel.BlabEdocDistGetCertRequest{EdocNum: edocNum, Eaddr: eaddr, Reason: reason}
	url := baseUrl + "/api/cert/save"
	appRes, err := ClientCall(http.MethodPost, url, nil, bodyData, &blabModel.BlabEdocDistGetCertResponse{})
	return appRes, err
}
