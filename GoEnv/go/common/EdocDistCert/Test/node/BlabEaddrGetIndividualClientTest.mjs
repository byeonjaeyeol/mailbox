import { v4 } from 'uuid';
import dateFormat, {masks} from 'dateformat';
import http from 'http';
import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 개인 공인전자주소 조회 테스트
function BlabEaddrGetIndividualTest() {
    blabClient.GetEaddr(clientConfig.server.host, clientConfig.server.port,
        clientConfig.individual.idn, clientConfig.auth.platformId,
        function(res) {
            console.log(res)
        });
}

BlabEaddrGetIndividualTest();