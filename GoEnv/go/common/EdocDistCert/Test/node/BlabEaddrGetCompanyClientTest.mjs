import { v4 } from 'uuid';
import dateFormat, {masks} from 'dateformat';
import http from 'http';
import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 법인 공인전자주소 조회 테스트
function BlabEaddrGetCompanyTest() {
    const response = blabClient.GetEaddr(clientConfig.server.baseUrl,
        clientConfig.company.idn, clientConfig.auth.platformId)
        .then(res => {
            console.log(res)
        })
}

BlabEaddrGetCompanyTest();