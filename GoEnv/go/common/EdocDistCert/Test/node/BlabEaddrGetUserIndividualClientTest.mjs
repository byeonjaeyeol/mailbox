import { v4 } from 'uuid';
import dateFormat, {masks} from 'dateformat';
import http from 'http';
import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 개인 공인전자주소 소유자정보 조회
function BlabEaddrGetUserIndividualTest() {
    blabClient.GetEaddrUser(clientConfig.server.baseUrl,
        clientConfig.individual.eaddr)
        .then(res => {
            console.log(res)
        });
}

BlabEaddrGetUserIndividualTest();