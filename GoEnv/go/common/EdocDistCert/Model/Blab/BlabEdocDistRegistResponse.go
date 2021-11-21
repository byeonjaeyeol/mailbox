package Blab

// BlabEdocDistRegistResponse 전자문서 유통정보 등록 응답
type BlabEdocDistRegistResponse struct {
	// resultCode 처리결과 (1:성공, 0:실패)
	ResultCode int8 `json:"resultCode" enums:"0,1" example:"1" validate:"required"`

	// errCode 오류코드
	ErrCode string `json:"errCode,omitempty" example:"ERR-01-304" maxLength:"10" validatee:"required"`
	// errMsg 오류메시지
	ErrMsg string `json:"errMsg,omitempty" example:"공인전자주소가 존재하지 않습니다." maxLength:"256""`

	// circulations 유통정보 배열
	Circulations []BlabEdocDistRegistCircResponse `json:"circulations,omitempty" maxLength:"500" validate:"required"`
}

func (br *BlabEdocDistRegistResponse) SetResult(resultCode int8, errCode string, errMsg string) {
	br.ResultCode = resultCode
	br.ErrCode = errCode
	br.ErrMsg = errMsg
}

func (br *BlabEdocDistRegistResponse) GetResultCode() int8 {
	return br.ResultCode
}

func (br *BlabEdocDistRegistResponse) GetErrCode() string {
	return br.ErrCode
}

func (br *BlabEdocDistRegistResponse) GetErrMsg() string {
	return br.ErrMsg
}
