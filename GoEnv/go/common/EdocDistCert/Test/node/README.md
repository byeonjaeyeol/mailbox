# 공인전자문서 유통 API Nodejs 클라이언트 모듈 및 테스트 모듈
## BlabClient.js
* 공인전자문서 유통 API 게이트웨이 호출 함수 모음

## *ClientTest.js
* BlabClient 단위 함수별 테스트 모듈
* 실행 방법
  * node BlabEaddrGetCompanyClientTest.js
* 실제 사용할 때에는 BlabClient에 있는 함수를 호출하면서 파라미터 값을 변경해야 함

## KISA API 대비 호출 함수 비교
| 번호 | 업무 | Method | KISA URI | BLAB URI | BlabClient 함수 | Test 파일 | 
|:---|:---|:---|:---|:---|:---|:---|
| 1 | 중계자 Access Token 발급 및 갱신 | POST | /auth/token | /auth/token | Nodejs에서는 미작업 | | 
| 2-1 | 개인 공인전자주소 등록 | POST | /api/eaddr | /api/eaddr/individual | PostEaddrRegistIndividual | BlabEaddrRegistIndividualClientTest.js |
| 2-2 | 법인 공인전자주소 등록 | POST | /api/eaddr | /api/eaddr/company | PostEaddrRegistCompany | BlabEaddrRegistCompanyClientTest.js |
| 3 | 공인전자주소 조회 | GET | /api/eaddr | /api/eaddr | GetEaddr | BlabEaddrGetCompanyClientTest.js<br>BlabEaddrGetIndividualClientTest.js |
| 4 | 공인전자주소 탈퇴 | PATCH | /api/eaddr | /api/eaddr | PatchEddrCancel | BlabEaddrCancelCompanyClientTest.js<br>BlabEaddrCancelIndividualClientTest.js |
| 5 | 공인전자주소 탈퇴이력 조회 | GET | /api/eaddr/canceled | /api/eaddr/canceled | GetEaddrGetCanceled | BlabEaddrGetCanceledCompanyClientTest.js<br>BlabEaddrGetCanceledIndividualClientTest.js |
| 6 | 공인전자주소 소유자정보 조회 | GET | /api/eaddr/user | /api/eaddr/user | GetEaddrUser | BlabEaddrGetUserCompanyClientTest.js<br>BlabEaddrGetUserIndividualClientTest.js |
| 7 | 개인 공인전자주소 소유자정보 수정 | PATCTH | /api/eaddr/user/individual | /api/eaddr/user/individual | PatchEddrUpdateUserIndividual | BlabEaddrUpdateUserIndividualClientTest.js |
| 8 | 법인 공인전자주소 소유자정보 수정 | POST | /api/eaddr/user/company | /api/eaddr/user/company | PostEaddrUpdateUserCompany | BlabEaddrUpdateUerCompanyClientTest.js |
| 9 | 전자문서 유통정보 등록 | POST | /api/circulation | /api/circulation | PostEdocDistRegist | BlabEdocDistRegistClientTest.js |
| 10 | 전자문서 유통정보 열람시각 등록 | PATCH | /api/circulation | /api/circulation | PatchEdocDistRead | BlabEdocDistReadClientTest.js |
| 11 | 전자문서 유통증명서 발급 | POST | /api/cert | /api/cert | 미작업 | |
| 12 | 전자문서 유통증명서 발급 후 게이트웨이에 저장 | POST | 없음 | /api/cert/save | PostEdocDistSaveCert | BlabEdocDistSaveCertClientTest.js |
| 13 | 전자문서 유통증명서 다운로드 | GET | 없음 | /api/cert/download | GetEdocDistDownloadCert | BlabEdocDistDownloadCertClientTest.js |
| 14 | 앱 서버용 전자문서 유통증명서 발급/저장 후 다운로드 | 없음 | 없음 | 12, 13 결합 | 12, 13 결합 | BlabEdocDistSaveAndDownloadCertWebTest.js |

## 웹 서버용 전자문서 유통증명서 발급/저장 후 다운로드 에제 확인
* node BlabEdocDistSaveAndDownloadWebTest.js
* 브라우저에서 http://localhost:2345/saveAndDownload 호출