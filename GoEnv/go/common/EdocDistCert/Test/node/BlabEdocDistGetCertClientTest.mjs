import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 미작업: 전자문서 유통증명서 발급 테스트
function BlabEdocDistGetCertTest() {
    blabClient.PostEdocDistGetCert(
        clientConfig.server.baseUrl,
        clientConfig.individual.edocNum,
        clientConfig.individual.eaddr,
        clientConfig.individual.reason)
    .then(res => {
        // console.log(res);
    });
}

BlabEdocDistGetCertTest();