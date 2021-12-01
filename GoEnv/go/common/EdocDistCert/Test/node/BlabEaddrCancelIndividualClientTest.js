const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');


// 개인 공인전자주소 탈퇴 테스트
function BlabEaddrCancelIndividualTest() {
    BlabClient.PatchEaddrCancel(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.eaddr,
        BlabClientConfig.individual.eaddrDelDate)
        .then(res => {
            console.log(res)
        });
}

BlabEaddrCancelIndividualTest();