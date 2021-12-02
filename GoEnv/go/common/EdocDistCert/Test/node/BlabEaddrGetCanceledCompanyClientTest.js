const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 법인 공인전자주소 탈퇴이력 조회 테스트
async function BlabEaddrGetCanceledCompanyTest() {
    const res = await BlabClient.GetEaddrCanceled(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.company.idn);
    console.log(res);
}

BlabEaddrGetCanceledCompanyTest();