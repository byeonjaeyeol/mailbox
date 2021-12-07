package Blab

// BlabCommonResponse 공통 응답 정보
type BlabCommonResponse struct {
	// resultCode 처리결과 (1:성공, 0:실패)
	ResultCode int8 `json:"resultCode" enums:"0,1" example:"1" validate:"required"`
	// errCode 오류코드, resultCode가 1이 아니면 errCode, errMsg 항목은 없음
	ErrCode string `json:"errCode,omitempty" example:"ERR-01-303" maxLength:"10" validatee:"required"`
	// errMsg 오류메시지, resultCode가 1이 아니면 errCode, errMsg 항목은 없음
	ErrMsg string `json:"errMsg,omitempty" example:"한국인터넷진흥원은 이미 등록된 공인전자주소입니다." maxLength:"256"`
}

func (br *BlabCommonResponse) SetResult(resultCode int8, errCode string, errMsg string) {
	br.ResultCode = resultCode
	br.ErrCode = errCode
	br.ErrMsg = errMsg
}

func (br *BlabCommonResponse) GetResultCode() int8 {
	return br.ResultCode
}

func (br *BlabCommonResponse) GetErrCode() string {
	return br.ErrCode
}

func (br *BlabCommonResponse) GetErrMsg() string {
	return br.ErrMsg
}
