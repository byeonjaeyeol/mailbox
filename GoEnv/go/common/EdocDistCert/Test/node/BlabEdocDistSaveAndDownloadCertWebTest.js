const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

var http = require('http');

// BlabEdocDistSaveAndDownloadCertWebTest
// 전자문서 유통증명서 발급 및 게이트웨이 저장, 유통증명서 다운로드 웹 서버에서 처리하는 예제
// node BlabDistSaveAndDownloadCertWebTsst.js를 실행한 뒤
// 브라우저에서 http://localhost:2345/saveAndDownload에 접속하면 유통증명서 pdf가 표시됨

var app = http.createServer(function(request, response) {
   var url = request.url;
   if (url != '/saveAndDownload') {
       response.writeHead(404)
       response.end();
       return;
   }

    var blabEdocDistSaveAndDownloadCert = async function blabEdocDistSaveAndDownloadCert() {
        // KISA에서 유통증명서를 발급 받아 게이트웨이에 저장
        // BlabClientConfig의 Eaddr, EdocNum, Reason을 유호한 값으로 지정한 뒤 호출해야 함
        const gwRes = await BlabClient.PostEdocDistSaveCert(
            BlabClientConfig.server.baseUrl,
            BlabClientConfig.individual.edocNum,
            BlabClientConfig.individual.eaddr,
            BlabClientConfig.individual.reason);

        console.log("gwRes", gwRes)

        // 게이트웨이에 저장된 유통증명서를 브라우저 또는 앱 단말로 다운로드
        // 게이트웨이에 저장된 유통증멍서 바이너리를 브라으저 또는 앱으로 전달하는 기능이며
        // 브라우저나 앱에서는 이 바아너리를 단말기에 저장하면 됨
        const res = await BlabClient.GetEdocDistDownloadCert(
            BlabClientConfig.server.baseUrl,
            gwRes.data.certNum,
            gwRes.data.fileName);
        // 바이너리라서 로그 출력은 하지 않음
        // console.log(res);
        // console.log(typeof res);
        console.log(res.length);

        // * 브라우저에서 미리보기만 할 때(다운로드는 미리보기에서 사용자가 직접 진행)
        // Content-Disposition을 없애고 application/pdf로 지정
        // * 브라우저에서 미리보기 없이 자동으로 다운로드하게 할 때
        //   1. Content-Disposition이 있으면 Content-Disposition의 filename으로 다운로드
        //   2. Content-Disposition 없이 application/octet-stream만 지정할 때에는 URL을 파일명으로 다운로드
        response.setHeader('Content-Type', 'application/pdf');
        // response.setHeader('Content-Type', 'application/octet-stream');
        response.setHeader('Content-Disposition', 'attachment; filename="' + gwRes.data.fileName + '"');
        response.setHeader('Content-Length', res.length);
        response.writeHead(200);

        response.end(res)
    };

   blabEdocDistSaveAndDownloadCert()
})

app.listen(2345)