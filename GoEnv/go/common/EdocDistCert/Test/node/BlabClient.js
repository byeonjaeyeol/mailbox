const { v4 } = require('uuid');
const strftime = require('strftime');
const axios = require('axios');
const querystring = require('querystring');
const FormData = require('form-data');
const Busboy = require('busboy');
const fs = require('fs');
const multipartParser = require('parse-multipart-data');
const { BlabClientConfig } = require('./BlabClientConfig.js');

exports.BlabClient = {
    getHeaders(contentType) {
        let  headers = {
            'platform-id': BlabClientConfig.auth.platformId,
            'req-UUID': v4(),
            'req-date': strftime('%Y-%m-%d %H:%M:%S', new Date())
        }

        if (contentType) {
           headers['Content-Type'] = contentType;
        }

        // console.log(headers)
        return { headers : headers }
    },

    // 개인 공인전자주소 등록
    async PostEaddrRegistIndividual(baseUrl, idn, eaddr, name, regDate) {
        const bodyData = {
            idn: idn,
            eaddr: eaddr,
            name: name,
            type: 0,
            regDate: regDate
        };

        const url = baseUrl + '/api/eaddr/individual';
        const response = await axios.post(url, bodyData, this.getHeaders());
        return response.data;
    },

    // 법인 공인전자주소 등록
    async PostEaddrRegistCompany(baseUrl, idn, eaddr, name, type, regDate, bizDocFilePath, regDocFilePath) {
        const bodyData = {
            idn: idn,
            eaddr: eaddr,
            name: name,
            type: type,
            regDate: regDate
        };

        const formData = new FormData();
        formData.append('msg', JSON.stringify(bodyData));
        formData.append('biz-doc.jpg', fs.createReadStream(bizDocFilePath));
        formData.append('reg-doc.jpg', fs.createReadStream(regDocFilePath));

        const url = baseUrl + '/api/eaddr/company';
        const response = await axios.post(url, formData,
              this.getHeaders(formData.getHeaders()['content-type'])
        );
        return response.data;
    },


    // 공인전자주소 조회
    async GetEaddr(baseUrl, idn, platformId) {
        const queryParam = {
           idn: idn,
           platformId: platformId
        };

        const url = baseUrl + '/api/eaddr?' + querystring.stringify(queryParam);
        const response = await axios.get(url, null, this.getHeaders());
        return response.data;
    },

    // 공인전자주소 탈퇴
    async PatchEaddrCancel(baseUrl, eaddr, delDate) {
        const bodyParam = {
            eaddr: eaddr,
            delDate: delDate
        };

        const url = baseUrl + '/api/eaddr';
        const response = await axios.patch(url, bodyParam, this.getHeaders());
        return response.data;
    },

    // 공인전자주소 탈퇴이력 조회
    async GetEaddrCanceled(baseUrl, idn) {
        const queryParam = {
           idn: idn
        };

        const url = baseUrl + '/api/eaddr/canceled?' + querystring.stringify(queryParam);
        const response = await axios.get(url, null, this.getHeaders());
        return response.data;
    },

    // 공인전자주소 소유자정보 조회
    async GetEaddrUser(baseUrl, eaddr) {
        const queryParam = {
            eaddr: eaddr
        };

        const url = baseUrl + '/api/eaddr/user?' + querystring.stringify(queryParam);
        const response = await axios.get(url, null, this.getHeaders());
        return response.data;
    },

    // 개인 공인전자주소 소유자정보 수정
    async PatchEaddrUpdateUserIndividual(baseUrl, eaddr, name, updDate) {
        const bodyData = {
            eaddr: eaddr,
            name: name,
            updDate: updDate
        }
        const url = baseUrl + '/api/eaddr/user/individual';
        const response = await axios.patch(url, bodyData, this.getHeaders());
        return response.data;
    },


    // 법인 공인전자주소 소유자정보 수정
    async PostEaddrUpdateUserCompany(baseUrl, eaddr, name, updDate, bizDocFilePath, regDocFilePath) {
        const bodyData = {
            eaddr: eaddr,
            name: name,
            updDate: updDate
        };

        const formData = new FormData();
        formData.append('msg', JSON.stringify(bodyData));
        formData.append('biz-doc.jpg', fs.createReadStream(bizDocFilePath));
        formData.append('reg-doc.jpg', fs.createReadStream(regDocFilePath));

        const url = baseUrl + '/api/eaddr/user/company';
        const response = await axios.post(url, formData,
            this.getHeaders(formData.getHeaders()['content-type'])
        );
        return response.data;
    },


    // 전자문서 유통정보 등록
    async PostEdocDistRegist(baseUrl, circulations) {
        const bodyData = {
            circulations: circulations
        };

        const url = baseUrl + '/api/circulation';
        const response = await axios.post(url, bodyData, this.getHeaders());
        return response.data;
    },


    // 전자문서 유통정보 열람일시 등록
    async PatchEdocDistRead(baseUrl, circulations) {
        const bodyData = {
            circulations: circulations
        }
        const url = baseUrl + '/api/circulation';
        const response = await axios.patch(url, bodyData, this.getHeaders());
        return response.data;
    },

    getDemoData() {
        let body = "";
        /*
        body += "------WebKitFormBoundaryvef1fLxmoUdYZWXp\r\n";
        body += "Content-Disposition: form-data; name=\"uploads[]\"; filename=\"A.txt\"\r\n";
        body += "Content-Type: text/plain\r\n",
            body += "\r\n\r\n";
        body += "@11X";
        body += "111Y\r\n";
        body += "111Z\rCCCC\nCCCC\r\nCCCCC@\r\n\r\n";
        body += "------WebKitFormBoundaryvef1fLxmoUdYZWXp\r\n";
        body += "Content-Disposition: form-data; name=\"uploads[]\"; filename=\"B.txt\"\r\n";
        body += "Content-Type: text/plain\r\n",
            body += "\r\n\r\n";
        body += "@22X";
        body += "222Y\r\n";
        body += "222Z\r222W\n2220\r\n666@\r\n";
        body += "------WebKitFormBoundaryvef1fLxmoUdYZWXp--\r\n";
        // return (new Buffer(body,'utf-8'));
         */
        body += '------WebKitFormBoundaryDtbT5UpPj83kllfw\r\n';
        body += 'Content-Disposition: form-data; name="uploads[]"; filename="sometext.txt"\r\n';
        body += 'Content-Type: application/octet-stream\r\n';
        body += '\r\n';
        body += 'hello how are you\r\n';
        body += '------WebKitFormBoundaryDtbT5UpPj83kllfw--\r\n';
        return (new Buffer(body,'utf-8'));
        // return body;
    },
    // 미완성: 전자문서 유통증명서 발급
    async PostEdocDistGetCert(baseUrl, edocNum, eaddr, reason) {
        const bodyData = {
            edocNum: edocNum,
            eaddr: eaddr,
            reason: reason
        };

        // const boundary = '------WebKitFormBoundaryvef1fLxmoUdYZWXp';
        const boundary = '------WebKitFormBoundaryDtbT5UpPj83kllfw';
        // const demoData = multipartParser.DemoData();
        const demoData = this.getDemoData()
        console.log(demoData)
        let parts = multipartParser.parse(demoData, boundary)
        console.log(parts)
        /*
        const url = baseUrl + '/api/cert';
        const response = await axios.post(url, bodyData, this.getHeaders());``
        console.log(response)
        console.log("HEADERS======", response.headers)
        let header = response.headers['content-type']
        let boundary  = header.split(' ')[1]
        boundary = header.split('=')[1]
        console.log("BOUNDARY1=", boundary)
        boundary = multipartParser.getBoundary(header)
        console.log("BOUNDARY2=", boundary)

        let parts = multipartParser.Parse(response.data, boundary);
        console.log(parts)
        for (let i = 0; i < parts.length; i++) {
            let part = parts[i];
            console.log(part)
        }

        return response.data;
         */
    },
    // 미완성: 전자문서 유통증명서 발급
    async PostEdocDistGetCertBackup2(baseUrl, edocNum, eaddr, reason) {
        const bodyData = {
            edocNum: edocNum,
            eaddr: eaddr,
            reason: reason
        };

        const url = baseUrl + '/api/cert';
        const options = {
           method: 'POST',
           url: url,
           data: bodyData,
           headers: this.getHeaders().headers,
           responseType: 'stream'
        };
        const response = await axios(options)
        console.log(response)
        const boundary = multipartParser.getBoundary(response.headers['content-type']);
        const tempContentType = "content-type: multipart/form-data; boundary="+boundary;
        var busboy = new Busboy({ headers: response.headers });
        busboy.on('file', function(fieldname, file, filename, encoding, mimetype) {
            console.log('File [' + fieldname + ']: filename: ' + filename + ', encoding: ' + encoding + ', mimetype: ' + mimetype);
            file.on('data', function(data) {
                console.log('File [' + fieldname + '] got ' + data.length + ' bytes');
            });
            file.on('end', function() {
                console.log('File [' + fieldname + '] Finished');
            });
        });
        busboy.on('field', function(fieldname, val, fieldnameTruncated, valTruncated, encoding, mimetype) {
            console.log('Field [' + fieldname + ']: value: ' + inspect(val));
        });
        busboy.on('finish', function() {
            console.log('Done parsing form!');
            res.writeHead(303, { Connection: 'close', Location: '/' });
            res.end();
        });
        response.data.pipe(busboy);
        // response.data.pipe(fs.createWriteStream("aaa.txt"))
    },

    // 미완성: 전자문서 유통증명서 발급
    async PostEdocDistGetCertBackup(baseUrl, edocNum, eaddr, reason) {
        const bodyData = {
            edocNum: edocNum,
            eaddr: eaddr,
            reason: reason
        };

        // const boundary = '------WebKitFormBoundaryvef1fLxmoUdYZWXp';
        const boundary = '------WebKitFormBoundaryDtbT5UpPj83kllfw';
        // const demoData = multipartParser.DemoData();
        const demoData = this.getDemoData()
        console.log(demoData)
        let parts = multipartParser.Parse(demoData, boundary)
        console.log(parts)
        /*
        const url = baseUrl + '/api/cert';
        const response = await axios.post(url, bodyData, this.getHeaders());``
        console.log(response)
        console.log("HEADERS======", response.headers)
        let header = response.headers['content-type']
        let boundary  = header.split(' ')[1]
        boundary = header.split('=')[1]
        console.log("BOUNDARY1=", boundary)
        boundary = multipartParser.getBoundary(header)
        console.log("BOUNDARY2=", boundary)

        let parts = multipartParser.Parse(response.data, boundary);
        console.log(parts)
        for (let i = 0; i < parts.length; i++) {
            let part = parts[i];
            console.log(part)
        }

        return response.data;
         */
    }
};
