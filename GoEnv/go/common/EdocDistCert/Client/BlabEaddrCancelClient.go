package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

func PatchEddrCancel(baseUrl string, eaddr string, delDate string) (*blabModel.BlabResponse, error) {
	bodyParam := blabModel.BlabEaddrCancelRequest{Eaddr: eaddr, DelDate: delDate}
	url := baseUrl + "/api/eaddr"
	appRes, err := ClientCall(http.MethodPatch, url, nil, bodyParam, &blabModel.BlabCommonResponse{})
	return appRes, err
}
