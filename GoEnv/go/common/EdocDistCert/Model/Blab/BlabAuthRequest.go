package Blab

// BlabAuthRequest Access Token, Refresh Token 발급 또는 갱신 요청 정보
type BlabAuthRequest struct {
	// grantType 인증구분값
	// * 0: 발급
	// * 1: 갱신
	GrantType int8 `json:"grantType,omitempty" example:"0" enums:"0,1" minimum:"0" maximum:"1"` // validator에서 0인 것은 required 오류가 발생해서 required 조건은 삭제. 대신 swagger에는 "필수" 항목으로 표시되지 않음
	// clientId 중계자플랫폼 클라이언트 ID
	ClientId string `json:"clientId,omitempty" example:"D3KFK3KFK2311FF4K" minLength:"16" maxLength:"16" validate:"required"`
	// clientSecret 클라이언트 비밀번호(발급 시 필수)
	ClientSecret string `json:"clientSecret,omitempty" example:"3K4K5JDK10DD3WK4"  minLength:"16" maxLength:"16"`
	// refreshToken 리프레시 토큰 (갱신 시 필수)
	RefreshToken string `json:"refreshToken,omitempty" example:"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ2cdC5jb....."  minLength:"256" maxLength:"256"`
}
