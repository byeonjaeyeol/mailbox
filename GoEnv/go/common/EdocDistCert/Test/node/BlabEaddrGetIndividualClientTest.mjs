import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 개인 공인전자주소 조회 테스트
function BlabEaddrGetIndividualTest() {
    blabClient.GetEaddr(clientConfig.server.baseUrl,
        clientConfig.individual.idn, clientConfig.auth.platformId)
        .then(res => {
            console.log(res)
        })
}

BlabEaddrGetIndividualTest();