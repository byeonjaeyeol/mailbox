const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 개인 공인전자주소 탈퇴이력 조회 테스트
async function BlabEaddrGetCanceledIndividualTest() {
    const res = await BlabClient.GetEaddrCanceled(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.idn);
    console.log(res);
}

BlabEaddrGetCanceledIndividualTest();