import { v4 } from 'uuid';
import dateFormat, {masks} from 'dateformat';
import http from 'http';
import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 개인 공인전자주소 등록 테스트
function BlabEaddrRegistIndividualTest() {
    blabClient.PostEaddrRegistIndividual(
        clientConfig.server.baseUrl,
        clientConfig.individual.idn,
        clientConfig.individual.eaddr,
        clientConfig.individual.name,
        clientConfig.individual.regDate)
        .then(res => {
            console.log(res)
        });
}

BlabEaddrRegistIndividualTest();