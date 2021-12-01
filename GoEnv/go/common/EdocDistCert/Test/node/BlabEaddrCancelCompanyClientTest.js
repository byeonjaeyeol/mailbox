const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 법인 공인전자주소 탈퇴 테스트
function BlabEaddrCancelCompanyTest() {
    BlabClient.PatchEaddrCancel(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.company.eaddr,
        BlabClientConfig.company.eaddrDelDate)
        .then(res => {
            console.log(res)
        });
}

BlabEaddrCancelCompanyTest();