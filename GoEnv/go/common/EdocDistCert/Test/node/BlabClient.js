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

    // 미완성: 전자문서 유통증명서 발급
    // PostEdocDistSaveCert로 게이트웨이에 저장 요청 후 GetEdocDistDownloadCert를 통해 실제로 다운로애 해야 함
    async PostEdocDistGetCert(baseUrl, edocNum, eaddr, reason) {
        const bodyData = {
            edocNum: edocNum,
            eaddr: eaddr,
            reason: reason
        };
        return {
            result: {
                code: "Not Implemented",
                description: "nodejs에서는 multipart/mixed 다운로드 형식이어서 지원하지 않습니다. PostEdocDistSaveCert 후 GetEdocDistDownloadCert를 사용해 주세요."
            }
        }
    },

    // 전자문서 유통증명서 게이트웨이에 저장 요청
    // PostEdocDistSaveCert로 게이트웨이에 저장 요청 후 GetEdocDistDownloadCert를 통해 실제로 다운로애 해야 함
    async PostEdocDistSaveCert(baseUrl, edocNum, eaddr, reason) {
        const bodyData = {
            edocNum: edocNum,
            eaddr: eaddr,
            reason: reason
        }
        const url = baseUrl + '/api/cert/save';
        const response = await axios.post(url, bodyData, this.getHeaders());
        return response.data;
    },

    // 전자문서 유통증명서 파일 다운로드
    // PostEdocDistSaveCert로 게이트웨이에 저장 요청 후 GetEdocDistDownloadCert를 통해 실제로 다운로애 해야 함
    async GetEdocDistDownloadCert(baseUrl, certNum, certFilename) {
        const queryParam = {
            certNum: certNum,
            certFilename: certFilename
        }
        const url = baseUrl + '/api/cert/download?' + querystring.stringify(queryParam);
        console.log(url)
        // config의 responseType: "arraybuffer"가 아니면 원본 바이너리 데이터가 유지되지 않음
        const config = {
           method: "GET",
           url: url,
           headers: this.getHeaders().headers,
           responseType: "arraybuffer"
        }
        const response = await axios(config);
        console.log("headers: ", response.headers)
        return response.data;
    },
};
