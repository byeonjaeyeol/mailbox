package Blab

// BlabEdocDistReadCircRequest 전자문서 유통정보 열람일시 등록 요청 열람정보
type BlabEdocDistReadCircRequest struct {
	// edocNum 전자문서번호
	EdocNum string `json:"edocNum,omitempty" example:"20180201_KISA000001_0001234567890" maxLength:"33" validate:"required"`

	// readDate 열람일시(YYYY-MM-DD HH24:MI:SS)
	ReadDate string `json:"readDate,omitempty" example:"2018-03-06 11:04:16" maxLength:"19"`
}
