const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 전자문서 유통증명서 게이트웨이에서 다운로드
async function BlabEdocDistDownloadCertTest() {
    const res = await BlabClient.GetEdocDistDownloadCert(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.certNum,
        BlabClientConfig.individual.certFilename);
    // 바이너리라서 로그 출력은 하지 않음
    // console.log(res);
    // console.log(typeof res);
    console.log(res.length);
}

BlabEdocDistDownloadCertTest();