const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 법인 공인전자주소 소유자정보 조회
function BlabEaddrGetUserCompanyTest() {
    BlabClient.GetEaddrUser(BlabClientConfig.server.baseUrl,
                BlabClientConfig.company.eaddr)
        .then(res => {
            console.log(res)
        });
}

BlabEaddrGetUserCompanyTest();