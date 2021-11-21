package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

func PatchEddrUpdateUserIndividual(baseUrl string, eaddr string, name string, updDate string) (*blabModel.BlabResponse, error) {
	bodyData := blabModel.BlabEaddrUpdateUserIndividualRequest{Eaddr: eaddr, Name: name, UpdDate: updDate}
	url := baseUrl + "/api/eaddr/user/individual"
	appRes, err := ClientCall(http.MethodPatch, url, nil, bodyData, &blabModel.BlabCommonResponse{})
	return appRes, err
}
