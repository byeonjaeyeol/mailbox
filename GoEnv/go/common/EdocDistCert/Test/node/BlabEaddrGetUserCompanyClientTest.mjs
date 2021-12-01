import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 법인 공인전자주소 소유자정보 조회
function BlabEaddrGetUserCompanyTest() {
    blabClient.GetEaddrUser(clientConfig.server.baseUrl,
                clientConfig.company.eaddr)
        .then(res => {
            console.log(res)
        });
}

BlabEaddrGetUserCompanyTest();