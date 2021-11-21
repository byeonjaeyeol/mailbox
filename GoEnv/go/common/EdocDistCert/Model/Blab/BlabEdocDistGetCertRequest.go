package Blab

// BlabEdocDistGetCertRequest 전자문서 유통증명서 발급 요청 정보
type BlabEdocDistGetCertRequest struct {
	// edocNum 전자문서번호
	EdocNum string `json:"edocNum,omitempty" example:"20180201_KISA000001_0001234567890" maxLength:"33" validate:"required"`

	// eaddr 유통증명서 요청 이용자 공인전자주소
	Eaddr string `json:"eaddr,omitempty" example:"kisa" maxLength:"100" validate:"required"`

	// reason 유통증명서 발급요청 사유
	Reason string `json:"reason,omitempty" example:"테스트 발급" maxLength:"200"`
}
