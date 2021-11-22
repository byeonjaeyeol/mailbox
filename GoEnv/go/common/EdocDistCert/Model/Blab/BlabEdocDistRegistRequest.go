package Blab

// BlabEdocDistRegistRequest 전자문서 유통정보 등록 요청 정보
type BlabEdocDistRegistRequest struct {
	// circulations 유통정보 배열
	Circulations []BlabEdocDistRegistCircRequest `json:"circulations,omitempty" maxLength:"500" validate:"required"`
}
