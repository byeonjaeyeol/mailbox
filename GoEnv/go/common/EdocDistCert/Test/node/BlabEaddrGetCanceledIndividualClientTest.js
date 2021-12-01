const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 개인 공인전자주소 탈퇴이력 조회 테스트
function BlabEaddrGetCanceledIndividualTest() {
    BlabClient.GetEaddrCanceled(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.idn)
        .then(res => {
            console.log(res)
        });
}

BlabEaddrGetCanceledIndividualTest();