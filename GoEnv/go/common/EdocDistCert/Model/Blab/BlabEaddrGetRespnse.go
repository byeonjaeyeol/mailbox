package Blab

// BlabEaddrGetResponse 공인전자주소 조회 응답 정보
type BlabEaddrGetResponse struct {
	// resultCode 처리결과 (1:성공, 0:실패)
	ResultCode int8 `json:"resultCode" enums:"0,1" example:"1" validate:"required"`
	// errCode 오류코드
	ErrCode string `json:"errCode,omitempty" example:"ERR-01-304" maxLength:"10" validatee:"required"`
	// errMsg 오류메시지
	ErrMsg string `json:"errMsg,omitempty" example:"공인전자주소가 존재하지 않습니다." maxLength:"256""`

	// name 이용자 명
	Name string `json:"name,omitempty" example:"한국인터넷진흥원" maxLength:"40""`

	// eaddrs 이용자 명
	Eaddrs []string `json:"eaddrs,omitempty" example:"[ \“kisa\”, \“한국인터넷진흥원_디지털문서팀\”]""`
}

func (br *BlabEaddrGetResponse) SetResult(resultCode int8, errCode string, errMsg string) {
	br.ResultCode = resultCode
	br.ErrCode = errCode
	br.ErrMsg = errMsg
}

func (br *BlabEaddrGetResponse) GetResultCode() int8 {
	return br.ResultCode
}

func (br *BlabEaddrGetResponse) GetErrCode() string {
	return br.ErrCode
}

func (br *BlabEaddrGetResponse) GetErrMsg() string {
	return br.ErrMsg
}
