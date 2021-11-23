package Client

import (
	blabModel "../Model/Blab"
	"net/http"
	netUrl "net/url"
)

// GetEaddrGetCanceled 공인전자주소 탈퇴이력 조회
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- idn string : 이용자 고유번호
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabEaddrGetCanceledResponse
//  - error
func GetEaddrGetCanceled(baseUrl string, idn string) (*blabModel.BlabResponse, error) {
	url := baseUrl + "/api/eaddr/canceled?idn=" + netUrl.QueryEscape(idn)
	appRes, err := ClientCall(http.MethodGet, url, nil, nil, &blabModel.BlabEaddrGetCanceledResponse{})
	return appRes, err
}
