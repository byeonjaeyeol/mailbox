const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 전자문서 유통증명서 게이트웨이에 저장 요청 테스트
async function BlabEdocDistSaveCertTest() {
    const res = await BlabClient.PostEdocDistSaveCert(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.edocNum,
        BlabClientConfig.individual.eaddr,
        BlabClientConfig.individual.reason);
    console.log(res);
}

BlabEdocDistSaveCertTest();