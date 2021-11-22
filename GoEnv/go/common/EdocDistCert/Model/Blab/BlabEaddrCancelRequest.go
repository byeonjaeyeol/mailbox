package Blab

// BlabEaddrCancelRequest 공인전자주소 탈퇴 요청 정보
type BlabEaddrCancelRequest struct {
	// eaddr 이용자 공인전자주소
	Eaddr string `json:"eaddr,omitempty" example:"kisa" maxLength:"100" validate:"required"`

	// name 이용자의 공인전자주소 서비스 탈퇴일시(YYYY-MM-DD HH24:MI:SS)
	DelDate string `json:"delDate,omitempty" example:"2021-03-31 17:00:00" maxLength:"19" validate:"required"`
}
