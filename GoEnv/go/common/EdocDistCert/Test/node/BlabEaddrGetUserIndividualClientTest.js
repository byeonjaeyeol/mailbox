const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 개인 공인전자주소 소유자정보 조회
async function BlabEaddrGetUserIndividualTest() {
    const res = await BlabClient.GetEaddrUser(BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.eaddr);
    console.log(res);
}

BlabEaddrGetUserIndividualTest();