package Blab

// BlabFileDownloadResponse 다운로드 응답
type BlabFileDownloadResponse struct {
	// resultCode 처리결과 (1:성공, 0:실패)
	ResultCode int8 `json:"resultCode" enums:"0,1" example:"1" validate:"required"`
	// errCode 오류코드, resultCode가 1이 아니면 errCode, errMsg 항목은 없음
	ErrCode string `json:"errCode,omitempty" example:"ERR-01-304" maxLength:"10" validatee:"required"`
	// errMsg 오류메시지, resultCode가 1이 아니면 errCode, errMsg 항목은 없음
	ErrMsg string `json:"errMsg,omitempty" example:"공인전자주소가 존재하지 않습니다." maxLength:"256"`

	// fileBytes 서버에서 응답한 파일 내용
	FileBytes []byte `json:"fileBytes"`
}

func (br *BlabFileDownloadResponse) SetResult(resultCode int8, errCode string, errMsg string) {
	br.ResultCode = resultCode
	br.ErrCode = errCode
	br.ErrMsg = errMsg
}

func (br *BlabFileDownloadResponse) GetResultCode() int8 {
	return br.ResultCode
}

func (br *BlabFileDownloadResponse) GetErrCode() string {
	return br.ErrCode
}

func (br *BlabFileDownloadResponse) GetErrMsg() string {
	return br.ErrMsg
}

func (br *BlabFileDownloadResponse) SetFileBytes(fileBytes []byte) {
	br.FileBytes = fileBytes
}

func (br *BlabFileDownloadResponse) GetFileBytes() []byte {
	return br.FileBytes
}
