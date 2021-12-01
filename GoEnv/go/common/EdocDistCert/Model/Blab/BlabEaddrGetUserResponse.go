package Blab

// BlabEaddrGetUserResponse 공인전자주소 조회 응답 정보
type BlabEaddrGetUserResponse struct {
	// resultCode 처리결과 (1:성공, 0:실패)
	ResultCode int8 `json:"resultCode" enums:"0,1" example:"1" validate:"required"`
	// errCode 오류코드
	ErrCode string `json:"errCode,omitempty" example:"ERR-01-304" maxLength:"10" validatee:"required"`
	// errMsg 오류메시지
	ErrMsg string `json:"errMsg,omitempty" example:"공인전자주소가 존재하지 않습니다." maxLength:"256""`

	// name 이용자 명
	Name string `json:"name,omitempty" example:"한국인터넷진흥원" maxLength:"40""`

	// type 이용자 구분 값
	// * 0: 개인
	// * 1: 법인
	// * 2: 국가기관
	// * 3: 공공기관
	// * 4: 지자체
	// * 9: 기타
	Type int8 `json:"type,omitempty" example:"3" enums:"0,1,2,3,4,9"`

	// regDate 이용자의 공인전자주소 서비스 가입일시(YYYY-MM-DD HH24:MI:SS)
	RegDate string `json:"regDate,omitempty" example:"2021-01-02 17:00:00" maxLength:"19"`
}

func (br *BlabEaddrGetUserResponse) SetResult(resultCode int8, errCode string, errMsg string) {
	br.ResultCode = resultCode
	br.ErrCode = errCode
	br.ErrMsg = errMsg
}

func (br *BlabEaddrGetUserResponse) GetResultCode() int8 {
	return br.ResultCode
}

func (br *BlabEaddrGetUserResponse) GetErrCode() string {
	return br.ErrCode
}

func (br *BlabEaddrGetUserResponse) GetErrMsg() string {
	return br.ErrMsg
}
