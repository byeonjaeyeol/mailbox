const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 개인 공인전자주소 등록 테스트
async function BlabEaddrRegistIndividualTest() {
    const res = await BlabClient.PostEaddrRegistIndividual(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.idn,
        BlabClientConfig.individual.eaddr,
        BlabClientConfig.individual.name,
        BlabClientConfig.individual.regDate);
    console.log(res);
}

BlabEaddrRegistIndividualTest();