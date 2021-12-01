const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 개인 공인전자주소 조회 테스트
async function BlabEaddrGetIndividualTest() {
    const res = await BlabClient.GetEaddr(BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.idn, BlabClientConfig.auth.platformId);
    console.log(res)
}

BlabEaddrGetIndividualTest();