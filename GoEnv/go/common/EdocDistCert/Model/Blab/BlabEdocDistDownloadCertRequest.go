package Blab

// BlabEdocDistDownloadCertRequest 전자문서 유통증명서 다운로드 요청 정보
type BlabEdocDistDownloadCertRequest struct {
	// certNum 유통증명서 일련번호
	CertNum string `json:"certNum" url:"certNum" example:"2021-1214-0000-00001" maxLength:"19" validate:"required"`

	// certFilename 유통증명서 파일명
	CertFilename string `json:"certFilename" url:"certFilename" example:"2021-1214-0000-0001-f1b9399d-4762-43fb-b97f-c6c28ce7e1ea.pdf" maxLength:"60" validate:"required"`
}
