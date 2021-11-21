package Blab

// BlabEdocDistReadResponse 전자문서 유통정보 열람일시 등록 응답
type BlabEdocDistReadResponse struct {
	// resultCode 처리결과 (1:성공, 0:실패)
	ResultCode int8 `json:"resultCode" enums:"0,1" example:"1" validate:"required"`

	// errCode 오류코드
	ErrCode string `json:"errCode,omitempty" example:"ERR-01-501" maxLength:"10" validatee:"required"`

	// errMsg 오류메시지
	ErrMsg string `json:"errMsg,omitempty" example:"유통증명서 오류 – 유통정보가 존재하지 않음" maxLength:"256""`

	// circulations 유통정보 배열
	Circulations []BlabEdocDistReadCircResponse `json:"circulations,omitempty" maxLength:"500" validate:"required"`
}

func (br *BlabEdocDistReadResponse) SetResult(resultCode int8, errCode string, errMsg string) {
	br.ResultCode = resultCode
	br.ErrCode = errCode
	br.ErrMsg = errMsg
}

func (br *BlabEdocDistReadResponse) GetResultCode() int8 {
	return br.ResultCode
}

func (br *BlabEdocDistReadResponse) GetErrCode() string {
	return br.ErrCode
}

func (br *BlabEdocDistReadResponse) GetErrMsg() string {
	return br.ErrMsg
}
