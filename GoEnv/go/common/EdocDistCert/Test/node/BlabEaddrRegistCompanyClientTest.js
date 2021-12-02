const { BlabClient } = require('./BlabClient');
const { BlabClientConfig } = require('./BlabClientConfig');

// 법인 공인전자주소 등록 테스트
async function BlabEaddrRegistCompanyTest() {
    const res = await BlabClient.PostEaddrRegistCompany(
        BlabClientConfig.server.baseUrl,
        BlabClientConfig.company.idn,
        BlabClientConfig.company.eaddr,
        BlabClientConfig.company.name,
        3, // 이용자 구분 값(0: 개인, 1: 법인, 2:국가기관, 3: 공공기관, 4: 지자체, 9:기타)
        BlabClientConfig.company.regDate,
        '../exampleFile/biz-doc.jpg',
        '../exampleFile/reg-doc.jpg');
    console.log(res)
}

BlabEaddrRegistCompanyTest();