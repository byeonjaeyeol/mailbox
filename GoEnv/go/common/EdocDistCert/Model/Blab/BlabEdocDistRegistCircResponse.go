package Blab

// BlabEdocDistRegistCircResponse 전자문서 유통정보 등록 응답 유통정보
// edocNum은 [날짜](8)_[중계자플랫폼內 관리코드](10)_[일련번호](13) 형태로 언더바(_)를 포함하여 33자리의 고정길이 문자열이다.
// 중계자플랫폼 관리코드는 중계자에서 임의로 지정하여 사용하는 값으로, 플랫폼내에서 고정하거나 업무에따라 생성하여 사용 할  수 있다.
type BlabEdocDistRegistCircResponse struct {
	// edocNum 전자문서번호
	EdocNum string `json:"edocNum,omitempty" example:"20180201_KISA000001_0001234567890" maxLength:"33" validate:"required"`

	// result 각 유통정보 별 처리결과
	// * 1: 등록성공
	// * 2: 이미등록된 유통정보
	// * 3: 전자문서유통 시각정보가 역전된 경우
	// * 4: 전자문서 송신시점에 송신자 공인전자주소가 존재하지 않는 경우
	// * 5: 전자문서 수신시점에 수신자 공인전자주소가 존재하지 않는 경우
	// * 6: 등록되지 않은 송신중계자 플랫폼ID
	// * 7: 등록되지 않은 수신중계자 플랫폼ID
	// * 9: 기타오류
	Result int8 `json:"result,omitempty" enums:"1,2,3,4,5,6,7,9" example:"1" validate:"required"`
}
