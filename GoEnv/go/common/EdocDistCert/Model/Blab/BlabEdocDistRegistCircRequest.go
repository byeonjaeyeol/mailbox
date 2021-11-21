package Blab

// BlabEdocDistRegistCircRequest 전자문서 유통정보 등록 요청 유통정보
// edocNum은 \[날짜\](8)_\[중계자플랫폼內 관리코드\](10)_\[일련번호\](13) 형태로 언더바(_)를 포함하여 33자리의 고정길이 문자열이다.
// 중계자플랫폼 관리코드는 중계자에서 임의로 지정하여 사용하는 값으로, 플랫폼내에서 고정하거나 업무에따라 생성하여 사용 할  수 있다.
type BlabEdocDistRegistCircRequest struct {
	// edocNum 전자문서번호
	// edocNum은 \[날짜\](8)_\[중계자플랫폼內 관리코드\](10)_\[일련번호\](13) 형태로 언더바(_)를 포함하여 33자리의 고정길이 문자열이다.
	// 중계자플랫폼 관리코드는 중계자에서 임의로 지정하여 사용하는 값으로, 플랫폼내에서 고정하거나 업무에따라 생성하여 사용 할  수 있다.
	EdocNum string `json:"edocNum,omitempty" example:"20180201_KISA000001_0001234567890" maxLength:"33" validate:"required"`

	// subject 전자문서제목
	Subject string `json:"subject,omitempty" example:"안내문" maxLength:"100" validate:"required"`

	// sendEaddr 송신자 공인전자주소
	SendEaddr string `json:"sendEaddr,omitempty" example:"kisa@kisa.or.kr" maxLength:"100" validate:"required"`

	// recvEaddr 수신자 공인전자주소
	RecvEaddr string `json:"recvEaddr,omitempty" example:"msip@msip.or.kr" maxLength:"100" validate:"required"`

	// sendPlatformId 송신 중계자플랫폼ID
	SendPlatformId string `json:"sendPlatformId,omitempty" example:"kisa" maxLength:"25" validate:"required"`

	// recvPlatformId 수신 중계자플랫폼ID
	RecvPlatformId string `json:"recvPlatformId,omitempty" example:"torpedo" maxLength:"25" validate:"required"`

	// sendDate 송신일시(YYYY-MM-DD HH24:MI:SS)
	SendDate string `json:"sendDate,omitempty" example:"2018-03-06 11:03:27" maxLength:"19" validate:"required"`

	// recvDate 수신일시(YYYY-MM-DD HH24:MI:SS)
	RecvDate string `json:"recvDate,omitempty" example:"2018-03-06 11:04:08" maxLength:"19" validate:"required"`

	// readDate 열람일시(YYYY-MM-DD HH24:MI:SS)
	ReadDate string `json:"readDate,omitempty" example:"2018-03-06 11:04:16" maxLength:"19"`

	// contentHash 본문해시값
	ContentHash string `json:"contentHash,omitempty" example:"c76ca7a43c937c15bcfd9eb302fa4515548" maxLength:"100" validate:"required"`

	// fileHashes 첨부파일 해시값 리스트(개수: 1..10) ex) fileHashes : [“hash1”, “hash2”, ..]
	FileHashes []string `json:"fileHashes,omitempty" example:"5445418d917651b438042564b21933257934..,0c5010e2a402d0e5cbe279d727500f3..." maxLength:"10"`
}
