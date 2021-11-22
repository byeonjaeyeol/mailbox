package Blab

// BlabEdocDistReadCircResponse 전자문서 유통정보 열람일시 등록 응답 열람정보
// edocNum은 [날짜](8)_[중계자플랫폼內 관리코드](10)_[일련번호](13) 형태로 언더바(_)를 포함하여 33자리의 고정길이 문자열이다.
// 중계자플랫폼 관리코드는 중계자에서 임의로 지정하여 사용하는 값으로, 플랫폼내에서 고정하거나 업무에따라 생성하여 사용 할  수 있다.
type BlabEdocDistReadCircResponse struct {
	// edocNum 전자문서번호
	EdocNum string `json:"edocNum,omitempty" example:"20180201_KISA000001_0001234567890" maxLength:"33" validate:"required"`

	// result는 각 유통정보에 등록결과 값
	// * 1: 등록성공
	// * 2: 열람일시가 이미 등록된 경우
	// * 3: 열람일시가 수신일시보다 빠른 경우(시각역전)
	// * 4: 전자문서번호가 등록되지 않은 경우
	// * 9: 기타오류
	Result int8 `json:"result,omitempty" enums:"1,2,3,4,9" example:"1" validate:"required"`
}
