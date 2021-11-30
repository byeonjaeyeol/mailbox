import { v4 } from 'uuid';
import dateFormat, {masks} from 'dateformat';
import http from 'http';
import rp from 'request-promise';
import fs from 'fs';
import clientConfig from './BlabClientConfig.mjs';

let BlabClient = {}

// 개인 공인전자주소 등록
BlabClient.PostEaddrRegistIndividual = function(host, port, idn, eaddr, name, regDate, callback) {
    const reqData = {
        idn: idn,
        eaddr: eaddr,
        name: name,
        type: 0,
        regDate: regDate
    };

    const bodyData = JSON.stringify(reqData)
    console.log("bodyData=", bodyData)

    const options = {
        host: host,
        port: port,
        path: '/api/eaddr/individual',
        method: 'POST',
        headers: {
            'platform-id': clientConfig.auth.platformId,
            'req-UUID': v4(),
            'req-date': dateFormat(new Date(), "yyyy-mm-dd H:MM:ss"),
            'Content-Type': 'application/json',
            'Content-Length': Buffer.byteLength(bodyData)
        }
    };

    const req = http.request(options, (res) => {
        if (res.statusCode !== 200) {
            console.error(`Did not get an OK from the server. Code: ${res.statusCode}`);
            res.resume();
            return;
        }

        let data = '';
        res.on('data', (chunk) => {
            data += chunk;
        });

        res.on('close', () => {
            // console.log(JSON.parse(data))
            callback(JSON.parse(data))
        })
    });

    req.write(bodyData);
    req.end();
};


// 법인 공인전자주소 등록
BlabClient.PostEaddrRegistCompany = function(host, port, idn, eaddr, name, type, regDate, bizDocFilePath, regDocFilePath, callback) {
    const reqData = {
        idn: idn,
        eaddr: eaddr,
        name: name,
        type: type,
        regDate: regDate
    };

    const bodyData = JSON.stringify(reqData)
    console.log("bodyData=", bodyData)

    const options = {
        uri: 'http://'+host + ':' + port + '/api/eaddr/company',
        preambleCRLF: true,
        postambleCRLF: true,
        method: 'POST',
        headers: {
            'platform-id': clientConfig.auth.platformId,
            'req-UUID': v4(),
            'req-date': dateFormat(new Date(), "yyyy-mm-dd H:MM:ss"),
            'Content-Type': 'multipart/mixed'
        },
        multipart: [
            {
               'Content-Type': 'application/json',
               'Content-Disposition': 'form-data; name="msg"',
               body: bodyData
            } ,
            {
                'Content-Type': 'image/jpeg',
                'Content-Disposition': 'form-data; name="file"; filename="biz-doc.jpg"',
                body: fs.createReadStream(bizDocFilePath)
            } ,
            {
                'Content-Type': 'image/jpeg',
                'Content-Disposition': 'form-data; name="file"; filename="reg-doc.jpg"',
                body: fs.createReadStream(regDocFilePath)
            }
        ]
    };

    rp(options, function(error, response, body) {
        if (error) {
           return console.error('upload failed', error);
        }

        // console.log('Upload successful!. Server responsed with:', body)
        callback(JSON.parse(body))
    });
};


// 공인전자주소 조회
BlabClient.GetEaddr = function(host, port, idn, platformId, callback) {
    const options = {
        host: host,
        port: port,
        path: '/api/eaddr?idn='+idn+"&platformId="+platformId,
        method: 'GET',
        headers: {
            'platform-id': clientConfig.auth.platformId,
            'req-UUID': v4(),
            'req-date': dateFormat(new Date(), "yyyy-mm-dd H:MM:ss")
        }
    };

    const req = http.get(options, (res) => {
        if (res.statusCode !== 200) {
            console.error(`Did not get an OK from the server. Code: ${res.statusCode}`);
            res.resume();
            return;
        }

        let data = '';
        res.on('data', (chunk) => {
            data += chunk;
        });

        res.on('close', () => {
            // console.log(JSON.parse(data))
            callback(JSON.parse(data))
        })
    });
};

clientConfig.individual.updDate,
// 공인전자주소 탈퇴이력 조회
BlabClient.GetEaddrCanceled = function(host, port, idn, callback) {
    const options = {
        host: host,
        port: port,
        path: '/api/eaddr/canceled?idn='+idn,
        method: 'GET',
        headers: {
            'platform-id': clientConfig.auth.platformId,
            'req-UUID': v4(),
            'req-date': dateFormat(new Date(), "yyyy-mm-dd H:MM:ss")
        }
    };

    const req = http.get(options, (res) => {
        if (res.statusCode !== 200) {
            console.error(`Did not get an OK from the server. Code: ${res.statusCode}`);
            res.resume();
            return;
        }

        let data = '';
        res.on('data', (chunk) => {
            data += chunk;
        });

        res.on('close', () => {
            // console.log(JSON.parse(data))
            callback(JSON.parse(data))
        })
    });
};

// 공인전자주소 소유자정보 조회
BlabClient.GetEaddrUser = function(host, port, eaddr, callback) {
    const options = {
        host: host,
        port: port,
        path: '/api/eaddr/user?eaddr='+eaddr,
        method: 'GET',
        headers: {
            'platform-id': clientConfig.auth.platformId,
            'req-UUID': v4(),
            'req-date': dateFormat(new Date(), "yyyy-mm-dd H:MM:ss")
        }
    };

    const req = http.get(options, (res) => {
        if (res.statusCode !== 200) {
            console.error(`Did not get an OK from the server. Code: ${res.statusCode}`);
            res.resume();
            return;
        }

        let data = '';
        res.on('data', (chunk) => {
            data += chunk;
        });

        res.on('close', () => {
            // console.log(JSON.parse(data))
            callback(JSON.parse(data))
        })
    });
};

// 개인 공인전자주소 소유자정보 수정
BlabClient.PatchEaddrUpdateUserIndividual = function(host, port, eaddr, name, updDate, callback) {
    const reqData = {
        eaddr: eaddr,
        name: name,
        updDate: updDate
    };

    const bodyData = JSON.stringify(reqData)
    console.log("bodyData=", bodyData)

    const options = {
        host: host,
        port: port,
        path: '/api/eaddr/user/individual',
        method: 'PATCH',
        headers: {
            'platform-id': clientConfig.auth.platformId,
            'req-UUID': v4(),
            'req-date': dateFormat(new Date(), "yyyy-mm-dd H:MM:ss"),
            'Content-Type': 'application/json',
            'Content-Length': Buffer.byteLength(bodyData)
        }
    };

    const req = http.request(options, (res) => {
        if (res.statusCode !== 200) {
            console.error(`Did not get an OK from the server. Code: ${res.statusCode}`);
            res.resume();
            return;
        }

        let data = '';
        res.on('data', (chunk) => {
            data += chunk;
        });

        res.on('close', () => {
            // console.log(JSON.parse(data))
            callback(JSON.parse(data))
        })
    });

    req.write(bodyData);
    req.end();
};


// 법인 공인전자주소 소유자정보 수정
BlabClient.PostEaddrUpdateUserCompany = function(host, port, eaddr, name, updDate, bizDocFilePath, regDocFilePath, callback) {
    const reqData = {
        eaddr: eaddr,
        name: name,
        updDate: updDate
    };

    const bodyData = JSON.stringify(reqData)
    console.log("bodyData=", bodyData)

    const options = {
        uri: 'http://'+host + ':' + port + '/api/eaddr/user/company',
        preambleCRLF: true,
        postambleCRLF: true,
        method: 'POST',
        headers: {
            'platform-id': clientConfig.auth.platformId,
            'req-UUID': v4(),
            'req-date': dateFormat(new Date(), "yyyy-mm-dd H:MM:ss"),
            'Content-Type': 'multipart/mixed'
        },
        multipart: [
            {
                'Content-Type': 'application/json',
                'Content-Disposition': 'form-data; name="msg"',
                body: bodyData
            } ,
            {
                'Content-Type': 'image/jpeg',
                'Content-Disposition': 'form-data; name="file"; filename="biz-doc.jpg"',
                body: fs.createReadStream(bizDocFilePath)
            } ,
            {
                'Content-Type': 'image/jpeg',
                'Content-Disposition': 'form-data; name="file"; filename="reg-doc.jpg"',
                body: fs.createReadStream(regDocFilePath)
            }
        ]
    };

    rp(options, function(error, response, body) {
        if (error) {
            return console.error('upload failed', error);
        }

        // console.log('Upload successful!. Server responsed with:', body)
        callback(JSON.parse(body))
    });
};


// 전자문서 유통정보 등록
BlabClient.PostEdocDistRegist = function(host, port, circulations, callback) {
    const reqData = {
        circulations: circulations
    };

    const bodyData = JSON.stringify(reqData)
    console.log("bodyData=", bodyData)

    const options = {
        host: host,
        port: port,
        path: '/api/circulation',
        method: 'POST',
        headers: {
            'platform-id': clientConfig.auth.platformId,
            'req-UUID': v4(),
            'req-date': dateFormat(new Date(), "yyyy-mm-dd H:MM:ss"),
            'Content-Type': 'application/json',
            'Content-Length': Buffer.byteLength(bodyData)
        }
    };

    const req = http.request(options, (res) => {
        if (res.statusCode !== 200) {
            console.error(`Did not get an OK from the server. Code: ${res.statusCode}`);
            res.resume();
            return;
        }

        let data = '';
        res.on('data', (chunk) => {
            data += chunk;
        });

        res.on('close', () => {
            // console.log(JSON.parse(data))
            callback(JSON.parse(data))
        })
    });

    req.write(bodyData);
    req.end();
};


// 전자문서 유통정보 열람일시 등록
BlabClient.PatchEdocDistRead = function(host, port, circulations, callback) {
    const reqData = {
        circulations: circulations
    };

    const bodyData = JSON.stringify(reqData)
    console.log("bodyData=", bodyData)

    const options = {
        host: host,
        port: port,
        path: '/api/circulation',
        method: 'PATCH',
        headers: {
            'platform-id': clientConfig.auth.platformId,
            'req-UUID': v4(),
            'req-date': dateFormat(new Date(), "yyyy-mm-dd H:MM:ss"),
            'Content-Type': 'application/json',
            'Content-Length': Buffer.byteLength(bodyData)
        }
    };

    const req = http.request(options, (res) => {
        if (res.statusCode !== 200) {
            console.error(`Did not get an OK from the server. Code: ${res.statusCode}`);
            res.resume();
            return;
        }

        let data = '';
        res.on('data', (chunk) => {
            data += chunk;
        });

        res.on('close', () => {
            // console.log(JSON.parse(data))
            callback(JSON.parse(data))
        })
    });

    req.write(bodyData);
    req.end();
};

// 미완성: 전자문서 유통증명서 발급
BlabClient.PostEdocDistGetCert = function(host, port, edocNum, eaddr, reason, callback) {
    const reqData = {
        edocNum: edocNum,
        eaddr: eaddr,
        reason: reason
    };

    const bodyData = JSON.stringify(reqData)
    console.log("bodyData=", bodyData)

    const options = {
        host: host,
        port: port,
        path: '/api/cert',
        method: 'POST',
        headers: {
            'platform-id': clientConfig.auth.platformId,
            'req-UUID': v4(),
            'req-date': dateFormat(new Date(), "yyyy-mm-dd H:MM:ss"),
            'Content-Type': 'application/json',
            'Content-Length': Buffer.byteLength(bodyData)
        }
    };

    const req = http.request(options, (res) => {
        if (res.statusCode !== 200) {
            console.error(`Did not get an OK from the server. Code: ${res.statusCode}`);
            res.resume();
            return;
        }

        let data = '';
        res.on('data', (chunk) => {
            data += chunk;
        });

        res.on('close', () => {
            console.log(data)
        })
    });

    req.write(bodyData);
    req.end();
};

export default BlabClient;