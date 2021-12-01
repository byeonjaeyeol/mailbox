import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 법인 공인전자주소 소유자정보 수정 테스트
function BlabEaddrUpdateUserCompanyTest() {
    blabClient.PostEaddrUpdateUserCompany(
        clientConfig.server.baseUrl,
        clientConfig.company.eaddr,
        clientConfig.company.name,
        clientConfig.company.updDate,
        '../exampleFile/biz-doc.jpg',
        '../exampleFile/reg-doc.jpg')
        .then(res => {
            console.log(res)
        });
}

BlabEaddrUpdateUserCompanyTest();