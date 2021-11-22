package Blab

// BlabEaddrUpdateUserCompanyRequest 법인 공인전자주소 소유자정보 수정 요청 정보
type BlabEaddrUpdateUserCompanyRequest struct {
	// eaddr 이용자 공인전자주소
	Eaddr string `json:"eaddr,omitempty" example:"kisa" maxLength:"100" validate:"required"`

	// name 이용자 명
	Name string `json:"name,omitempty" example:"한국인터넷진흥원" maxLength:"40" validate:"required"`

	// updDate 중계자시스템에서 이용자 정보가 변경된 일시(YYYY-MM-DD HH24:MI:SS)
	UpdDate string `json:"updDate,omitempty" example:"2021-01-02 17:00:00" maxLength:"19" validate:"required"`
}
