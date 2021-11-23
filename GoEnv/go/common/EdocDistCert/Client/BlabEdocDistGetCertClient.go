package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

// PostEdocDistGetCert 전자문서 유통증명서 발급
// Content-Type은 multipart/mixed임
// BlabEdocDistGetCertResponse의 Filename에 첨부파일명이 입력됨
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- edocNum string : 전자문서번호
//	- eaddr string : 유통증명서 요청 이용자 공인전자주소
//	- reason string : 유통증명서 발급요청 사유
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabEdocDistGetCertResponse
//  - error
func PostEdocDistGetCert(baseUrl string, edocNum string, eaddr string, reason string) (*blabModel.BlabResponse, error) {
	bodyData := blabModel.BlabEdocDistGetCertRequest{EdocNum: edocNum, Eaddr: eaddr, Reason: reason}
	url := baseUrl + "/api/cert"
	appRes, err := ClientCall(http.MethodPost, url, nil, bodyData, &blabModel.BlabEdocDistGetCertResponse{})
	return appRes, err
}
