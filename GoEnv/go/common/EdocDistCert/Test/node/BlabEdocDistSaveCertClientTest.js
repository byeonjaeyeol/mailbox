const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 전자문서 유통증명서 발급 후 게이트웨이에 저장 테스트
// 게이트웨이에서 저장하고 저장된 파일을 다운로드하려면 GetEdocDistDownloadCert를 사용해야 함
// nodejs 웹 서버에서의 사용 예제는 BlabEdocDistSaveAndDownloadCertWebTest.js를 참조
async function BlabEdocDistSaveCertTest() {
    const res = await BlabClient.PostEdocDistSaveCert(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.edocNum,
        BlabClientConfig.individual.eaddr,
        BlabClientConfig.individual.reason);
    console.log(res);
}

BlabEdocDistSaveCertTest();