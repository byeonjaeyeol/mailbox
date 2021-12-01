const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 개인 공인전자주소 소유자정보 수정 테스트
function BlabEaddrUpdateUserIndividualTest() {
    BlabClient.PatchEaddrUpdateUserIndividual(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.eaddr,
        BlabClientConfig.individual.name,
        BlabClientConfig.individual.updDate)
        .then(res => {
            console.log(res)
        });
}

BlabEaddrUpdateUserIndividualTest();