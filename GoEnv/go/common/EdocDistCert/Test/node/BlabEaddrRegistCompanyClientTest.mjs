import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 법인 공인전자주소 등록 테스트
function BlabEaddrRegistCompanyTest() {
    blabClient.PostEaddrRegistCompany(
        clientConfig.server.baseUrl,
        clientConfig.company.idn,
        clientConfig.company.eaddr,
        clientConfig.company.name,
        3, // 이용자 구분 값(0: 개인, 1: 법인, 2:국가기관, 3: 공공기관, 4: 지자체, 9:기타)
        clientConfig.company.regDate,
        '../exampleFile/biz-doc.jpg',
        '../exampleFile/reg-doc.jpg')
        .then(res => {
            console.log(res)
        });
}

BlabEaddrRegistCompanyTest();