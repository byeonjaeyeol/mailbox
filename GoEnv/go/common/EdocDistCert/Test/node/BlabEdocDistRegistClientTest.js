const strftime = require('strftime');
const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 전자문서 유통정보 등록 테스트
async function BlabEdocDistRegistTest() {
    const todayDate = new Date();
    const today = strftime('%Y%m%d', todayDate);
    const nowTime = strftime('%H%M%S', todayDate);

    let circulations = [];
    for (let idx = 0; idx < 1; idx++) {
        const tempEdocNum =
                today
                + "_" + "devmns1234".padStart(10, '0')
                + "_" + nowTime + String(idx + 1).padStart(7, '0');
        const orderStr = ''+ (idx + 1)
        const circData = {
            // edocNum 형식
            // edocNum은 [날짜](8)_[중계자플랫폼內 관리코드](10)_[일련번호](13) 형태로 언더바(_)를 포함하여 33자리의 고정길이 문자열이다.
            // 중계자플랫폼 관리코드는 중계자에서 임의로 지정하여 사용하는 값으로,
            // 플랫폼내에서 고정하거나 업무에따라 생성하여 사용 할  수 있다.
            edocNum: tempEdocNum,
            subject: 'subject_' + orderStr,
            sendEaddr: BlabClientConfig.company.eaddr,
            recvEaddr: BlabClientConfig.individual.eaddr,
            sendPlatformId: BlabClientConfig.auth.platformId,
            recvPlatformId: BlabClientConfig.auth.platformId,
            sendDate: strftime('%Y-%m-%d %H:%M:%S', todayDate),
            recvDate: strftime('%Y-%m-%d %H:%M:%S', todayDate),
            // readDate: strftime('%Y-%m-%d %H:%M:%S', todayDate),
            contentHash: "ContentHash_" + orderStr,
            fileHashes: ['fileHash1', 'fileHash2'],
        }

        circulations.push(circData);
    }

    const res = await BlabClient.PostEdocDistRegist(
        BlabClientConfig.server.baseUrl, circulations);
    console.log(res);
    console.log(res.data.circulations);
}

BlabEdocDistRegistTest();