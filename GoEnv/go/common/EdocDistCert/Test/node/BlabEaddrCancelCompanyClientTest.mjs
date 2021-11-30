import { v4 } from 'uuid';
import dateFormat, {masks} from 'dateformat';
import http from 'http';
import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 법인 공인전자주소 탈퇴 테스트
function BlabEaddrCancelCompanyTest() {
    blabClient.PatchEaddrCancel(
        clientConfig.server.host,
        clientConfig.server.port,
        clientConfig.company.eaddr,
        clientConfig.company.eaddrDelDate,
        function(res) {
            console.log(res)
        });
}

BlabEaddrCancelCompanyTest();