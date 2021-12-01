const strftime = require('strftime');
const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 전자문서 유통정보 열람일시 등록 테스트
function BlabEdocDistReadTest() {
    const todayDate = new Date();
    const today = strftime('%Y%m%d', todayDate);
    const nowTime = strftime('%H%M%S', todayDate);

    let circulations = [];
    // for (let idx = 0; idx < 1; idx++) {
        const circData = {
            edocNum: BlabClientConfig.individual.edocNum,
            readDate: strftime('%Y-%m-%d %H:%M:%S', todayDate)
        }

        circulations.push(circData);
    // }

    BlabClient.PatchEdocDistRead(
        BlabClientConfig.server.baseUrl,
        circulations)
        .then(res => {
            console.log(res);
            console.log(res.data.circulations);
        });
}

BlabEdocDistReadTest();