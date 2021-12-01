import { v4 } from 'uuid';
import dateFormat, {masks} from 'dateformat';
import http from 'http';
import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 법인 공인전자주소 탈퇴이력 조회 테스트
function BlabEaddrGetCanceledCompanyTest() {
    blabClient.GetEaddrCanceled(
        clientConfig.server.baseUrl,
        clientConfig.company.idn)
        .then(res => {
            console.log(res)
        });
}

BlabEaddrGetCanceledCompanyTest();