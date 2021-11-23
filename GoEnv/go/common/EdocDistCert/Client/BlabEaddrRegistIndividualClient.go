package Client

import (
	blabModel "../Model/Blab"
	"net/http"
)

// PostEaddrRegistIndividual 개인 공인전자주소 등록
// * 공인전자주소는 중계자플랫폼內에서 유일한값이며 영문대소문자구분을 하지 않는다.
// Params
// 	- baseUrl string : 게이트웨이 URL:port
//	- idn string : 이용자 고유번호(개인: CI, 법인: 사업자번호)
//	- eaddr string : 이용자 공인전자주소
//	- name string : 이용자 명
//	- type int8 : 이용자 구분 값(0: 개인, 1: 법인, 2:국가기관, 3: 공공기관, 4: 지자체, 9:기타)
//	- regDate string : 이용자의 공인전자주소 서비스 가입일시
// Returns
//  - *blabModel.BlabResponse: Data는 *BlabCommonResponse
//  - error
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
