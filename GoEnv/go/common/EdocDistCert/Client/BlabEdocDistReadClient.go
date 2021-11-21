package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

func PatchEdocDistRead(baseUrl string, circulations []blabModel.BlabEdocDistReadCircRequest) (*blabModel.BlabResponse, error) {
	bodyParam := blabModel.BlabEdocDistReadRequest{Circulations: circulations}
	url := baseUrl + "/api/circulation"
	appRes, err := ClientCall(http.MethodPatch, url, nil, bodyParam, &blabModel.BlabEdocDistReadResponse{})
	return appRes, err
}
