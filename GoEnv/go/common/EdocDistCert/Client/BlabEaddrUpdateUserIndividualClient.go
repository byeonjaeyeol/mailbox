package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

// PatchEddrUpdateUserIndividual 개인 공인전자주소 소유자정보 수정
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- eaddr string : 이용자 공인전자주소
//	- name string : 이용자 명
//	- updDate string : 중계자시스템에서 이용자 정보가 변경된 일시
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabCommonResponse
//  - error
func PatchEddrUpdateUserIndividual(baseUrl string, eaddr string, name string, updDate string) (*blabModel.BlabResponse, error) {
	bodyData := blabModel.BlabEaddrUpdateUserRequest{Eaddr: eaddr, Name: name, UpdDate: updDate}
	url := baseUrl + "/api/eaddr/user/individual"
	appRes, err := ClientCall(http.MethodPatch, url, nil, bodyData, &blabModel.BlabCommonResponse{})
	return appRes, err
}
