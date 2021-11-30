import { v4 } from 'uuid';
import dateFormat, {masks} from 'dateformat';
import http from 'http';
import blabClient from './BlabClient.mjs';
import clientConfig from './BlabClientConfig.mjs';

// 개인 공인전자주소 소유자정보 수정 테스트
function BlabEaddrUpdateUserIndividualTest() {
    blabClient.PatchEaddrUpdateUserIndividual(
        clientConfig.server.host,
        clientConfig.server.port,
        clientConfig.individual.eaddr,
        clientConfig.individual.name,
        clientConfig.individual.updDate,
        function(res) {
            console.log(res)
        });
}

BlabEaddrUpdateUserIndividualTest();