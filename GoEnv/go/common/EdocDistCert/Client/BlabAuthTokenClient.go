package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

func PostAuthToken(baseUrl string, grantType int8, clientId string, clientSecret string, refreshToken string) (*blabModel.BlabResponse, error) {
	bodyParam := blabModel.BlabAuthRequest{GrantType: grantType, ClientId: clientId, ClientSecret: clientSecret, RefreshToken: refreshToken}
	url := baseUrl + "/auth/token"
	appRes, err := ClientCall(http.MethodPost, url, nil, bodyParam, &blabModel.BlabAuthResponse{})
	return appRes, err
}
