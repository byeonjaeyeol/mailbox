const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 개인 공인전자주소 소유자정보 수정 테스트
async function BlabEaddrUpdateUserIndividualTest() {
    const res = await BlabClient.PatchEaddrUpdateUserIndividual(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.eaddr,
        BlabClientConfig.individual.name,
        BlabClientConfig.individual.updDate);
    console.log(res);
}

BlabEaddrUpdateUserIndividualTest();