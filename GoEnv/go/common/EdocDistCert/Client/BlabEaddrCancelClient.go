package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

// PatchEddrCancel 공인전자주소 탈퇴
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- eaddr string : 이용자 공인전자주소
//	- delDate string : 이용자의 공인전자주소 서비스 탈퇴일시
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabCommonResponse
//  - error
func PatchEddrCancel(baseUrl string, eaddr string, delDate string) (*blabModel.BlabResponse, error) {
	bodyParam := blabModel.BlabEaddrCancelRequest{Eaddr: eaddr, DelDate: delDate}
	url := baseUrl + "/api/eaddr"
	appRes, err := ClientCall(http.MethodPatch, url, nil, bodyParam, &blabModel.BlabCommonResponse{})
	return appRes, err
}
