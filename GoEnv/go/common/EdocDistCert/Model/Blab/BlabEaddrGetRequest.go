package Blab

// BlabEaddrGetRequest 공인전자주소 조회 요청 정보
// 중계자 자신의 플랫폼이 보유한 공인전자주소 조회시에는 idn 파라미터만 사용하며, platformId 파라미터는 사용하지 않는다.
// platformId 파라미터는 타 중계자 플랫폼이 보유하고 있는 공인전자주소 조회시에만 사용하며, 사전에 KISA와 타 중계자 간의 협의를 거친 후 사용 가능하다.
// annotation 설명
// json: json 변경시, swagger에서도 사용
// url: go-querystring/query에서 query호 변경 시
// in:"query=idn" 쿼리 파라미터를 구조체로 바꿀 때
// example, maxLength, minLangh, minimum, maximum: wagger에서 살용
// validate: validator와 swagger에서 사용
type BlabEaddrGetRequest struct {
	// idn 이용자 고유번호(개인: CI, 법인: 사업자번호)
	// 법인일 경우 idn에 사업자등록번호가 입력되는데 하이픈(‘-’)을 사용하지 않는다.
	Idn string `json:"idn" url:"idn" in:"query=idn" example:"1358207931" maxLength:"100" validate:"required"`

	// PlatformId 이용자 공인전자주소
	// 중계자 자신의 플랫폼이 보유한 공인전자주소 조회시에는 idn 파라미터만 사용하며, platformId 파라미터는 사용하지 않는다.
	// 조회대상 중계자플랫폼 ID(타 중계자의 플랫폼이 보유한 공인전자주소 조회시에만 사용)
	PlatformId string `json:"platformId,omitempty" url:"platformId" in:"query=platformId" example:"abce-28-efghijklmn" maxLength:"25"`
}
