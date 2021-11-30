import dateFormat, {masks} from 'dateformat';
import util from 'util';
import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 전자문서 유통정보 열람일시 등록 테스트
function BlabEdocDistReadTest() {
    const todayDate = new Date();
    const today = dateFormat(todayDate, "yyyymmdd");
    const nowTime = dateFormat(todayDate, "H:MM:ss");

    let circulations = [];
    // for (let idx = 0; idx < 1; idx++) {
        const circData = {
            edocNum: clientConfig.individual.edocNum,
            readDate: dateFormat(todayDate, 'yyyy-mm-dd H:MM:ss')
        }

        circulations.push(circData);
    // }

    blabClient.PatchEdocDistRead(
        clientConfig.server.host,
        clientConfig.server.port,
        circulations,
        function(res) {
            console.log(res);
            console.log(res.data.circulations);
        });
}

BlabEdocDistReadTest();