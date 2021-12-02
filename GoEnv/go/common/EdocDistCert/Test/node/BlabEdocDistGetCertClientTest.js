const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 미작업: 전자문서 유통증명서 발급 테스트
async function BlabEdocDistGetCertTest() {
    const res = await BlabClient.PostEdocDistGetCert(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.edocNum,
        BlabClientConfig.individual.eaddr,
        BlabClientConfig.individual.reason);
    console.log('데이터가 바이너리라 출력하지 않음')
    // console.log(res);
}

BlabEdocDistGetCertTest();