package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

func GetEaddr(baseUrl string, idn string, platformId string) (*blabModel.BlabResponse, error) {
	queryParam := blabModel.BlabEaddrGetRequest{Idn: idn, PlatformId: platformId}
	url := baseUrl + "/api/eaddr"
	appRes, err := ClientCall(http.MethodGet, url, queryParam, nil, &blabModel.BlabEaddrGetResponse{})
	return appRes, err
}
