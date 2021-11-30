import { v4 } from 'uuid';
import dateFormat, {masks} from 'dateformat';
import http from 'http';
import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 개인 공인전자주소 탈퇴 테스트
function BlabEaddrCancelIndividualTest() {
    blabClient.PatchEaddrCancel(
        clientConfig.server.host,
        clientConfig.server.port,
        clientConfig.individual.eaddr,
        clientConfig.individual.eaddrDelDate,
        function(res) {
            console.log(res)
        });
}

BlabEaddrCancelIndividualTest();