package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

func PostEaddrRegistIndividual(baseUrl string, idn string, eaddr string, name string, regDate string) (*blabModel.BlabResponse, error) {
	bodyParam := blabModel.BlabEaddrRegistRequest{
		Idn:     idn,
		Eaddr:   eaddr,
		Name:    name,
		Type:    0,
		RegDate: regDate,
	}
	url := baseUrl + "/api/eaddr/individual"
	appRes, err := ClientCall(http.MethodPost, url, nil, bodyParam, &blabModel.BlabCommonResponse{})
	return appRes, err
}
