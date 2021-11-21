package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

func PostEdocDistGetCert(baseUrl string, edocNum string, eaddr string, reason string) (*blabModel.BlabResponse, error) {
	bodyData := blabModel.BlabEdocDistGetCertRequest{EdocNum: edocNum, Eaddr: eaddr, Reason: reason}
	url := baseUrl + "/api/cert"
	appRes, err := ClientCall(http.MethodPost, url, nil, bodyData, &blabModel.BlabEdocDistGetCertResponse{})
	return appRes, err
}
