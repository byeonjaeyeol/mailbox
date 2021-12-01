const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 미작업: 전자문서 유통증명서 발급 테스트
function BlabEdocDistGetCertTest() {
    BlabClient.PostEdocDistGetCert(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.edocNum,
        BlabClientConfig.individual.eaddr,
        BlabClientConfig.individual.reason)
    .then(res => {
        // console.log(res);
    });
}

BlabEdocDistGetCertTest();