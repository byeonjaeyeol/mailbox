package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

// PostEdocDistRegist 전자문서 유통정보 등록
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- circulations []BlabEdocDistRegistCircRequest : 유통정보 배열(최대 500개)
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabEdocDistRegistResponse
//  - error
func PostEdocDistRegist(baseUrl string, circulations []blabModel.BlabEdocDistRegistCircRequest) (*blabModel.BlabResponse, error) {
	bodyParam := blabModel.BlabEdocDistRegistRequest{Circulations: circulations}
	url := baseUrl + "/api/circulation"
	appRes, err := ClientCall(http.MethodPost, url, nil, bodyParam, &blabModel.BlabEdocDistRegistResponse{})
	return appRes, err
}
