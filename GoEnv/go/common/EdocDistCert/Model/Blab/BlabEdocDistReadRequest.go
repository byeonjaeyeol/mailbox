package Blab

// BlabEdocDistReadRequest 전자문서 유통정보 열람일시 등록 요청 정보
type BlabEdocDistReadRequest struct {
	// circulations 유통정보 배열
	Circulations []BlabEdocDistReadCircRequest `json:"circulations,omitempty" maxLength:"500" validate:"required"`
}
