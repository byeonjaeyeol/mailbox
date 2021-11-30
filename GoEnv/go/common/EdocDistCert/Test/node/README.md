# 공인전자문서 유통 API Nodejs 클라이언트 모듈 및 테스트 모듈
## BlabClient.mjs
* 공인전자문서 유통 API 게이트웨이 호출 함수 모음

## *ClientTest.mjs
* BlabClient 단위 함수별 테스트 모듈
* 실행 방법
  * node BlabEaddrGetCompanyClientTest.mjs
* 실제 사용할 때에는 BlabClient에 있는 함수를 호출하면서 파라미터 값을 변경해야 함

## KISA API 대비 호출 함수 비교
| 번호 | 업무 | Method | KISA URI | BLAB URI | BlabClient 함수 | Test 파일 | 
|:---|:---|:---|:---|:---|:---|:---|
| 1 | 중계자 Access Token 발급 및 갱신 | POST | /auth/token | /auth/token | Nodejs에서는 미작업 | | 
| 2-1 | 개인 공인전자주소 등록 | POST | /api/eaddr | /api/eaddr/individual | PostEaddrRegistIndividual | BlabEaddrRegistIndividualClientTest.mjs |
| 2-2 | 법인 공인전자주소 등록 | POST | /api/eaddr | /api/eaddr/company | PostEaddrRegistCompany | BlabEaddrRegistCompanyClientTest.mjs |
| 3 | 공인전자주소 조회 | GET | /api/eaddr | /api/eaddr | GetEaddr | BlabEaddrGetCompanyClientTest.mjs<br>BlabEaddrGetIndividualClientTest.mjs |
| 4 | 공인전자주소 탈퇴 | PATCH | /api/eaddr | /api/eaddr | PatchEddrCancel | BlabEaddrCancelCompanyClientTest.mjs<br>BlabEaddrCancelIndividualClientTest.mjs |
| 5 | 공인전자주소 탈퇴이력 조회 | GET | /api/eaddr/canceled | /api/eaddr/canceled | GetEaddrGetCanceled | BlabEaddrGetCanceledCompanyClientTest.mjs<br>BlabEaddrGetCanceledIndividualClientTest.mjs |
| 6 | 공인전자주소 소유자정보 조회 | GET | /api/eaddr/user | /api/eaddr/user | GetEaddrUser | BlabEaddrGetUserCompanyClientTest.mjs<br>BlabEaddrGetUserIndividualClientTest.mjs |
| 7 | 개인 공인전자주소 소유자정보 수정 | PATCTH | /api/eaddr/user/individual | /api/eaddr/user/individual | PatchEddrUpdateUserIndividual | BlabEaddrUpdateUserIndividualClientTest.mjs |
| 8 | 법인 공인전자주소 소유자정보 수정 | POST | /api/eaddr/user/company | /api/eaddr/user/company | PostEaddrUpdateUserCompany | BlabEaddrUpdateUerCompanyClientTest.mjs |
| 9 | 전자문서 유통정보 등록 | POST | /api/circulation | /api/circulation | PostEdocDistRegist | BlabEdocDistRegistClientTest.mjs |
| 10 | 전자문서 유통정보 수정 | PATCH | /api/circulation | /api/circulation | PatchEdocDistRead | BlabEdocDistReadClientTest.mjs |
| 11 | 전자문서 유통증명서 발급 | POST | /api/cert | /api/cert | 미작업 | |

급하게 만드느라 내부 모듈들 정리가 되지는 않았습니다.

원하는 개발 방향이나 nodejs의 http client lib을 변경하고자 하면 이야기해 주세요.

<strong>특히 모듈 구성 방법에 대해서 알려 주시면 수정하도록 하겠습니다.</strong>
