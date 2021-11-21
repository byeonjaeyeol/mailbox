package Blab

// BlabEaddrGetUserRequest 공인전자주소 소유자 정보 요청 정보
type BlabEaddrGetUserRequest struct {
	// eaddr 이용자 공인전자주소
	Eaddr string `json:"eaddr,omitempty" url:"eaddr" example:"kisa" maxLength:"100" validate:"required"`
}
