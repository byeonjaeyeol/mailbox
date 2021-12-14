const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

var http = require('http');
var app = http.createServer(function(request, response) {
   var url = request.url;
   if (url != '/saveAndDownload') {
       response.writeHead(404)
       response.end();
       return;
   }

    // 전자문서 유통증명서 게이트웨이에 저장 요청
    var blabEdocDistSaveAndDownloadCert = async function blabEdocDistSaveAndDownloadCert() {
        const gwRes = await BlabClient.PostEdocDistSaveCert(
            BlabClientConfig.server.baseUrl,
            BlabClientConfig.individual.edocNum,
            BlabClientConfig.individual.eaddr,
            BlabClientConfig.individual.reason);

        console.log("gwRes", gwRes)
        const res = await BlabClient.GetEdocDistDownloadCert(
            BlabClientConfig.server.baseUrl,
            gwRes.data.certNum,
            gwRes.data.fileName);
        // 바이너리라서 로그 출력은 하지 않음
        // console.log(res);
        // console.log(typeof res);
        console.log(res.length);
        response.setHeader('Content-Type', 'application/pdf');
        response.setHeader('Content-Disposition', 'attachment; filename="' + gwRes.data.fileName + '"');
        response.setHeader('Content-Length', res.length);
        response.writeHead(200);

        response.end(res)
    };

   blabEdocDistSaveAndDownloadCert()
})

/**
// 전자문서 유통증명서 게이트웨이에 저장 요청
async function blabEdocDistSaveCert() {
    const gwRes = await BlabClient.PostEdocDistSaveCert(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.individual.edocNum,
        BlabClientConfig.individual.eaddr,
        BlabClientConfig.individual.reason);
    return gwRes;
};

// 전자문서 유통증명서 게이트웨이에서 다운로드
async function blabEdocDistDownloadCert(gwRes, response) {
    console.log("gwRes", gwRes)
    const res = await BlabClient.GetEdocDistDownloadCert(
        BlabClientConfig.server.baseUrl,
        gwRes.data.certNum,
        gwRes.data.filename);
    // 바이너리라서 로그 출력은 하지 않음
    // console.log(res);
    // console.log(typeof res);
    console.log(res.length);
    response.setHeader('Content-Type', 'application/pdf');
    response.setHeader('Content-Disposition', 'attachment; filename="aaa.pdf"');
    response.setHeader('Content-Length', res.length);
    response.writeHead(200);

    response.end(res)
};
**/

app.listen(2345)