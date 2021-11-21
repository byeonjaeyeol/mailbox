package Blab

// BlabEaddrRegistRequest 공인전자주소 등록 요청 정보
type BlabEaddrRegistRequest struct {
	// idn 이용자 고유번호(개인: CI, 법인: 사업자번호)
	// 법인일 경우 idn에 사업자등록번호가 입력되는데 하이픈(‘-’)을 사용하지 않는다.
	Idn string `json:"idn,omitempty" example:"1358207931" maxLength:"100" validate:"required,max=100"`

	// eaddr 이용자 공인전자주소
	// 공인전자주소는 중계자플랫폼內에서 유일한값이며 영문대소문자구분을 하지 않는다.
	Eaddr string `json:"eaddr,omitempty" example:"kisa" maxLength:"100" validate:"required,max=100"`

	// name 이용자 명
	// 개인 이외의 이용자명은 사업자등록증에 표기된 법인명(단체명)으로 등록해야 한다.
	Name string `json:"name,omitempty" example:"한국인터넷진흥원" maxLength:"40" validate:"required,max=40"`

	// type 이용자 구분 값: 필수임 golang number 0 validation 이슈로 swagger에서는 표시하지 못함`
	// * 0: 개인
	// * 1: 법인
	// * 2: 국가기관
	// * 3: 공공기관
	// * 4: 지자체
	// * 9: 기타
	Type int8 `json:"type,omitempty" example:"3" enums:"0,1,2,3,4,9" /* validate:"required" */`
	/*
		원래 validate:"required"로 처리해야 하는데 golang의 validator가 숫자인 경우 0이 아닌 것을 required로 처리하고 있어서 swagger용 required에서 제외했음
	*/

	// regDate 이용자의 공인전자주소 서비스 가입일시(YYYY-MM-DD HH24:MI:SS)
	RegDate string `json:"regDate,omitempty" example:"2021-01-02 17:00:00" maxLength:"19" validate:"required,myDatetime"`
}
