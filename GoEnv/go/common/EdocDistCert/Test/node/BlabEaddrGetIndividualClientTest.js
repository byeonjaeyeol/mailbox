const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 개인 공인전자주소 조회 테스트
function BlabEaddrGetIndividualTest() {
    BlabClient.GetEaddr(BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.idn, BlabClientConfig.auth.platformId)
        .then(res => {
            console.log(res)
        })
}

BlabEaddrGetIndividualTest();