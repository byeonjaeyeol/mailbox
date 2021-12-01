const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 법인 공인전자주소 조회 테스트
async function BlabEaddrGetCompanyTest() {
    const res = await BlabClient.GetEaddr(BlabClientConfig.server.baseUrl,
        BlabClientConfig.company.idn, BlabClientConfig.auth.platformId);
    console.log(res);
}

BlabEaddrGetCompanyTest();