package Client

import (
	blabModel "../Model/Blab"
	"net/http"
	netUrl "net/url"
)

func GetEaddrGetCanceled(baseUrl string, idn string) (*blabModel.BlabResponse, error) {
	url := baseUrl + "/api/eaddr/canceled?idn=" + netUrl.QueryEscape(idn)
	appRes, err := ClientCall(http.MethodGet, url, nil, nil, &blabModel.BlabEaddrGetCanceledResponse{})
	return appRes, err
}
