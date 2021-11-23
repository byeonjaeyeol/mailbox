package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

// GetEaddr 공인전자주소 조회
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- idn string : 이용자 고유번호
//	- platformId string : 조회대상 중계자플랫폼 ID(타 중계자의 플랫폼이 보유한 공인전자주소 조회시에만 사용)
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabEaddrGetResponse
//  - error
func GetEaddr(baseUrl string, idn string, platformId string) (*blabModel.BlabResponse, error) {
	queryParam := blabModel.BlabEaddrGetRequest{Idn: idn, PlatformId: platformId}
	url := baseUrl + "/api/eaddr"
	appRes, err := ClientCall(http.MethodGet, url, queryParam, nil, &blabModel.BlabEaddrGetResponse{})
	return appRes, err
}
