# 공인전자문서 유통 API Golang용 클라이언트 모듈 및 테스트 모듈
## 폴더 구조
| 폴더 | 설명 |
|---|---|
| `Client` | 실제로 클라이언트에서 사용하는 API 기능 단위 함수 모음 
| `Const` | 상수 정의 
| `IF_Error` | 에러 구조 정의 
| `Model` | 애플리케이션에서 사용하는 구조체 모델 모음. 주로 요청/응답 구조의 DTO 중심 
| `Test` | `Client`를 사용하는 테스트 예제 
| `Test/exampleFile` | 테스트용 파일(사업자등록증 사본용 가짜 jpg(biz-doc.jpg), 공인전자주소 등록 신청서 가짜 jpg(reg-doc.jpg) 
| `Test/TestConfig` | 테스트 환경 설정 처리 관련 모음.<br>**_BlabClientConfig.yml_** 에 URL 등 테스트 환경 설정 
| `Validator` | 요청 데이터 검사용 모듈 |

## KISA API 대비 호출 함수 비교
| 번호 | 업무 | Method | KISA URI | BLAB URI | BLAB Client 파일 | BLAB Client 함수 | Test 파일 | 
|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | 중계자 Access Token 발급 및 갱신 | POST | /auth/token | /auth/token | BlabAuthTokenClient.go | PostAuthToken | BlabAuthTokenClientTest.go | 
| 2-1 | 개인 공인전자주소 등록 | POST | /api/eaddr | /api/eaddr/individual | BlabEaddrRegistIndividualClient.go | PostEaddrRegistIndividual | BlabEaddrRegistIndividualClientTest.go |
| 2-2 | 법인 공인전자주소 등록 | POST | /api/eaddr | /api/eaddr/company | BlabEaddrRegistCompanyClient .go | PostEaddrRegistCompany | BlabEaddrRegistCompanyClientTest.go |
| 3 | 공인전자주소 조회 | GET | /api/eaddr | /api/eaddr | BlabEaddrGetClient.go | GetEaddr | BlabEaddrGetCompanyClientTest.go<br>BlabEaddrGetIndividualClientTest.go |
| 4 | 공인전자주소 탈퇴 | PATCH | /api/eaddr | /api/eaddr | BlabEaddrCancelClient.go | PatchEddrCancel | BlabEaddrCancelCompanyClientTest.go<br>BlabEaddrCancelIndividualClientTest.go |
| 5 | 공인전자주소 탈퇴이력 조회 | GET | /api/eaddr/canceled | /api/eaddr/canceled | BlabEaddrGetCanceledClient.go | GetEaddrGetCanceled | BlabEaddrGetCanceledCompanyClientTest.go<br>BlabEaddrGetCanceledIndividualClientTest.go |
| 6 | 공인전자주소 소유자정보 조회 | GET | /api/eaddr/user | /api/eaddr/user | BlabEaddrGetUserClient.go | GetEaddrUser | BlabEaddrGetUserCompanyClientTest.go<br>BlabEaddrGetUserIndividualClientTest.go |
| 7 | 개인 공인전자주소 소유자정보 수정 | PATCTH | /api/eaddr/user/individual | /api/eaddr/user/individual | BlabEaddrUpdateUserIndividualClient.go | PatchEddrUpdateUserIndividual | BlabEaddrUpdateUserIndividualClientTest.go |
| 8 | 법인 공인전자주소 소유자정보 수정 | POST | /api/eaddr/user/company | /api/eaddr/user/company | BlabEaddrUpdateUserCompanyClient.go | PostEaddrUpdateUserCompany | BlabEaddrUpdateUserCompanyClientTest.go |
| 9 | 전자문서 유통정보 등록 | POST | /api/circulation | /api/circulation | BlabEdocDistRegistClient.go | PostEdocDistRegist | BlabEdocDistRegistClientTest.go |
| 10 | 전자문서 유통정보 수정 | PATCH | /api/circulation | /api/circulation | BlabEdocDistReadClient.go | PatchEdocDistRead | BlabEdocDistReadClientTest.go |
| 11 | 전자문서 유통증명서 발급 | POST | /api/cert | /api/cert | BlabEdocDistGetCertClient.go | PostEdocDistGetCert | BlabEdocDistGetCertClientTes.go |

## 파일 저장 경로 설정
* 기본: 실행 경로의 + files/EdocDistCert/apps"
* 변경 방법
  * BlabClient.SetFileSavePath("저장하고자하는파일경로")
  * 권장 경로
    * 서버: /data/blab/files/EdocDistCert/apps
    * 개발 노트북: 사용자홈디렉터리/blabData/files/EdocDistCert/apps
* 실제 파일 저장 위치
  * BLAB -> KISA : fileSavePath+"/toKisa/YYYY/YYYYMM/YYYYMMDD/실제파일명"
  * KISA -> BLAB : fileSavePath+/fromKisa/YYYYMM/YYYYMMDD/실제파일명"
* 테스트 환경
  * Test/TestConfig/BlabClientConfig.yml에서 fileSavePath 지정
  * Test/TestClientConfig.go의 LoadTestClientConfig 함수 참조

## 추가 또는 협의해야 할 것들
* Result에는 Blab 내부 구조에 맞춘 Result/Data이며 Data에는 KISA의 응답을 그대로 담았는데 변경 필요 여부

