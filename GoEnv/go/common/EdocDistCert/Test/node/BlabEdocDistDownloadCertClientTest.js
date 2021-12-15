const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 전자문서 유통증명서 게이트웨이에 저장된 것 다운로드 테스트
// PostEdocDistSaveCert를 사용하여 파일 정보를 먼저 게이트웨이에 지정해야 함
// nodejs 웹 서버에서의 사용 예제는 BlabEdocDistSaveAndDownloadCertWebTest.js를 참조
async function BlabEdocDistDownloadCertTest() {
    const res = await BlabClient.GetEdocDistDownloadCert(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.certNum,
        BlabClientConfig.individual.certFilename);
    // 바이너리라서 로그 출력은 하지 않음
    // console.log(res);
    // console.log(typeof res);
    console.log(res.length);
    /*
        실제 사용 예제는 BlabEdocDistSaveAndDownloadWebTest.js 참조
        // * 브라우저에서 미리보기만 할 때(다운로드는 미리보기에서 사용자가 직접 진행)
        // Content-Disposition을 없애고 application/pdf로 지정
        // * 브라우저에서 미리보기 없이 자동으로 다운로드하게 할 때
        //   1. Content-Disposition이 있으면 Content-Disposition의 filename으로 다운로드
        //   2. Content-Disposition 없이 application/octet-stream만 지정할 때에는 URL을 파일명으로 다운로드
        response.setHeader('Content-Type', 'application/pdf');
        response.setHeader('Content-Disposition', 'attachment; filename="' + gwRes.data.fileName + '"');
        response.setHeader('Content-Length', res.length);
        response.writeHead(200);

        response.end(res)
     */
}

BlabEdocDistDownloadCertTest();