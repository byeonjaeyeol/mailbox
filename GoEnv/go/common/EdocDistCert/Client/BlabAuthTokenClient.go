package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

// PostAuthToken 중계자 Access Token 발급 및 갱신
// 게이트웨이에서 처리하므로 클라이언트에서 직접 호출하는 경우는 없음
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- grantType int8 : 인증구분값 (0: 발급, 1: 갱신)
//	- clientId string : 중계자플랫폼 클라이언트 ID
//	- clientSecret string : 클라이언트 비밀번호(발급 시 필수)
//	- refreshToken string : 리프레시 토큰 (갱신 시 필수)
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabAuthResponse
//  - error
func PostAuthToken(baseUrl string, grantType int8, clientId string, clientSecret string, refreshToken string) (*blabModel.BlabResponse, error) {
	bodyParam := blabModel.BlabAuthRequest{GrantType: grantType, ClientId: clientId, ClientSecret: clientSecret, RefreshToken: refreshToken}
	url := baseUrl + "/auth/token"
	appRes, err := ClientCall(http.MethodPost, url, nil, bodyParam, &blabModel.BlabAuthResponse{})
	return appRes, err
}
