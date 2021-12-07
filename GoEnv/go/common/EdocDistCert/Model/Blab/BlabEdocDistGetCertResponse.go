package Blab

// BlabEdocDistGetCertResponse 공통 응답 정보
type BlabEdocDistGetCertResponse struct {
	// resultCode 처리결과 (1:성공, 0:실패)
	ResultCode int8 `json:"resultCode" enums:"0,1" example:"1" validate:"required"`
	// errCode 오류코드, resultCode가 1이 아니면 errCode, errMsg 항목은 없음
	ErrCode string `json:"errCode,omitempty" example:"ERR-01-303" maxLength:"10" validatee:"required"`
	// errMsg 오류메시지, resultCode가 1이 아니면 errCode, errMsg 항목은 없음
	ErrMsg string `json:"errMsg,omitempty" example:"한국인터넷진흥원은 이미 등록된 공인전자주소입니다." maxLength:"256"`

	// certNum 유통증명서 일련번호
	CertNum string `json:"certNum,omitempty" example:"2021-0301-0001-1558" maxLength:"19" validatee:"required"`

	// filename
	// 원래 KISA 전문에는 없는데 문서에는 일련번호.pdf 파일을 준다고 했으나 실제로는 uuid.pdf가 전송되어 파일면을 전달
	Filename string `json:"fileName"`
	// fileSavePath
	// 파일이 저장된 경로
	FileSavePath string `json:"fileSavePath"`
}

func (br *BlabEdocDistGetCertResponse) SetResult(resultCode int8, errCode string, errMsg string) {
	br.ResultCode = resultCode
	br.ErrCode = errCode
	br.ErrMsg = errMsg
}

func (br *BlabEdocDistGetCertResponse) GetResultCode() int8 {
	return br.ResultCode
}

func (br *BlabEdocDistGetCertResponse) GetErrCode() string {
	return br.ErrCode
}

func (br *BlabEdocDistGetCertResponse) GetErrMsg() string {
	return br.ErrMsg
}
func (br *BlabEdocDistGetCertResponse) SetFilename(filename string) {
	br.Filename = filename
}
func (br *BlabEdocDistGetCertResponse) SetFileSavePath(fileSavePath string) {
	br.FileSavePath = fileSavePath
}
