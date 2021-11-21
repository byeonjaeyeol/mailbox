package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

func PostEdocDistRegist(baseUrl string, circulations []blabModel.BlabEdocDistRegistCircRequest) (*blabModel.BlabResponse, error) {
	bodyParam := blabModel.BlabEdocDistRegistRequest{Circulations: circulations}
	url := baseUrl + "/api/circulation"
	appRes, err := ClientCall(http.MethodPost, url, nil, bodyParam, &blabModel.BlabEdocDistRegistResponse{})
	return appRes, err
}
