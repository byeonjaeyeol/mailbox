package Blab

// BlabAuthResponse AccessToken 응답 정보
type BlabAuthResponse struct {
	// resultCode 처리결과 (1:성공, 0:실패)
	ResultCode int8 `json:"resultCode" enums:"0,1" example:"1" validate:"required"`

	// errCode 오류코드, resultCode가 1이 아니면 errCode, errMsg 항목은 없음
	ErrCode string `json:"errCode,omitempty" example:"ERR-01-XXX" maxLength:"10"`

	// errMsg 오류메시지, resultCode가 1이 아니면 errCode, errMsg 항목은 없음
	ErrMsg string `json:"errMsg,omitempty" example:"알 수 없는 오류입니다." maxLength:"256"`

	// accessToken 엑세스 토큰
	AccessToken string `json:"accessToken,omitempty" example:"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ2cdC5jb....." maxLength:"16"`

	// accessExpiresIn 엑세스 토큰 만료시간(분)
	AccessExpiresIn int32 `json:"accessExpiresIn,omitempty" example:"43200"`

	// accessExpireDate 엑세스 토큰 만료일시
	AccessExpireDate string `json:"accessExpireDate,omitempty" example:"2021-06-07 18:00:00" maxLength:"19"`

	// refreshToken 리프레시 토큰
	RefreshToken string `json:"refreshToken	,omitempty" example:"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ2cdC5jb....." maxLength:"256"`

	// refreshExpiresIn 리프레시 토큰 만료시간(분)
	RefreshExpiresIn int32 `json:"refreshExpiresIn,omitempty" example:"86400"`

	// refreshExpireDate 리프레시 토큰 만료일시
	RefreshExpireDate string `json:"refreshExpireDate,omitempty" example:"2021-09-07" maxLength:"19"`
}
