package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

// PatchEdocDistRead 전자문서 유통정보 열람일시 등록
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- circulations []BlabEdocDistReadCircRequest : 유통정보 배열(최대 500개)
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabEdocDistReadResponse
//  - error
func PatchEdocDistRead(baseUrl string, circulations []blabModel.BlabEdocDistReadCircRequest) (*blabModel.BlabResponse, error) {
	bodyParam := blabModel.BlabEdocDistReadRequest{Circulations: circulations}
	url := baseUrl + "/api/circulation"
	appRes, err := ClientCall(http.MethodPatch, url, nil, bodyParam, &blabModel.BlabEdocDistReadResponse{})
	return appRes, err
}
