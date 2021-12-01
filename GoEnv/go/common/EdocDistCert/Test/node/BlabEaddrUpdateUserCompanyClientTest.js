const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 법인 공인전자주소 소유자정보 수정 테스트
function BlabEaddrUpdateUserCompanyTest() {
    BlabClient.PostEaddrUpdateUserCompany(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.company.eaddr,
        BlabClientConfig.company.name,
        BlabClientConfig.company.updDate,
        '../exampleFile/biz-doc.jpg',
        '../exampleFile/reg-doc.jpg')
        .then(res => {
            console.log(res)
        });
}

BlabEaddrUpdateUserCompanyTest();