const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 개인 공인전자주소 등록 테스트
function BlabEaddrRegistIndividualTest() {
    BlabClient.PostEaddrRegistIndividual(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.idn,
        BlabClientConfig.individual.eaddr,
        BlabClientConfig.individual.name,
        BlabClientConfig.individual.regDate)
        .then(res => {
            console.log(res)
        });
}

BlabEaddrRegistIndividualTest();