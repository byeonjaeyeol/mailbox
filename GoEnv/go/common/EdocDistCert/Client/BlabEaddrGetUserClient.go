package Client

import (
	blabModel "../Model/Blab"
	"net/http"
	netUrl "net/url"
)

// GetEaddrUser 공인전자주소 소유자정보 조회
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- eaddr string : 이용자 공인전자주소
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabEaddrGetUserRespons
//  - error
func GetEaddrUser(baseUrl string, eaddr string) (*blabModel.BlabResponse, error) {
	url := baseUrl + "/api/eaddr/user?eaddr=" + netUrl.QueryEscape(eaddr)
	appRes, err := ClientCall(http.MethodGet, url, nil, nil, &blabModel.BlabEaddrGetUserResponse{})
	return appRes, err
}
