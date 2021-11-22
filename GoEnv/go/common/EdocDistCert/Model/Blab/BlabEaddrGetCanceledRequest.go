package Blab

// BlabEaddrGetCanceledRequest 공인전자주소 탈퇴 이력 조회 목록 요청 정보
type BlabEaddrGetCanceledRequest struct {
	// idn 이용자 고유번호(개인: CI, 법인: 사업자번호)
	// 법인일 경우 idn에 사업자등록번호가 입력되는데 하이픈(‘-’)을 사용하지 않는다.
	Idn string `json:"idn" url:"idn" in:"query=idn" example:"1358207931" maxLength:"100" validate:"required"`
}
