package Client

import (
	blabModel "../Model/Blab"
	"net/http"
	netUrl "net/url"
)

func GetEaddrUser(baseUrl string, eaddr string) (*blabModel.BlabResponse, error) {
	url := baseUrl + "/api/eaddr/user?eaddr=" + netUrl.QueryEscape(eaddr)
	appRes, err := ClientCall(http.MethodGet, url, nil, nil, &blabModel.BlabEaddrGetUserResponse{})
	return appRes, err
}
