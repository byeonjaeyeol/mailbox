import { v4 } from 'uuid';
import dateFormat, {masks} from 'dateformat';
import http from 'http';
import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 법인 공인전자주소 소유자정보 조회
function BlabEaddrGetUserCompanyTest() {
    blabClient.GetEaddrUser(clientConfig.server.host, clientConfig.server.port,
                clientConfig.company.eaddr,
        function(res) {
            console.log(res)
        });
}

BlabEaddrGetUserCompanyTest();