const fs = require('fs');
const crypto = require('crypto');
const request = require('request-promise-native');
const server = "http://211.253.86.102:33001";

var args = process.argv.slice(2);
console.log('Client args: ', args);
var pi = args[0];
var name = args[1];
var id = args[2];

console.log(pi + ", " + name + ", " + id);

fs.readFile('./data.json', 'utf8', (error, strJson) => {
    if (error) return console.log(error);
    console.log(strJson);
    var dataJson = JSON.parse(strJson);

    dataJson.data["request-id"] = id;
    dataJson.data.pi = pi;
    dataJson.data.ci = "thisisscreret!";
    dataJson.data.re_name = dataJson.data.re_name + " " + name;
    dataJson.data.ddj_nm = name + " 담당자";
    dataJson.data.grjlist[0].grj_nm = "근로자01 " + name;
    dataJson.data.grjlist[1].grj_nm = "근로자02 " + name;
    dataJson.data.grjlist[2].grj_nm = "근로자03 " + name;
    dataJson.data.grjlist[3].grj_nm = "근로자04 " + name;
    dataJson.data.grjlist[4].grj_nm = "근로자05 " + name;
    dataJson.data.grjlist[5].grj_nm = "근로자06 " + name;
    dataJson.data.grjlist[6].grj_nm = "근로자07 " + name;
    dataJson.data.grjlist[7].grj_nm = "근로자08 " + name;
    dataJson.data.grjlist[8].grj_nm = "근로자09 " + name;
    dataJson.data.grjlist[9].grj_nm = "근로자10 " + name;

    strDataJson = JSON.stringify(dataJson.data);
    console.log("data : " + strDataJson);

    dataJson["data-hash"] = crypto.createHash('sha256').update(strDataJson).digest('hex');

    console.log("new \r\n" + JSON.stringify(dataJson));

    console.log("client collect ()");

    var messages =[];
    messages.push(dataJson);

    var initializePromise = collectInitialize(1, messages);
  
    initializePromise.then(function(result) {
        console.log("result : " + JSON.stringify(result));
    }, function(err) {
        console.log("err : " + err);
    });
});


function collectInitialize(count, messages) {
  
    var options = {
      uri: server + '/convert',
      headers: {
        'Content-Type' : 'application/json',
        'cache-control' : 'no-cache',
        'User-Agent' : 'POSTOK_1.2.21',
        'Authorization' : '11001-60002',
        'Data' : '2021-11-11 19:11:11'
      },
      body: {
          "count" : count,
          "msg" : messages
      },
      json: true
    };
  
    return new Promise(function(resolve, reject) {
      // Do async job
      request.post(options, function(err, resp, body) {
        if (err) {
          console.log('error : ' + err);
          reject(err);
        } else {
          console.log('resp : ' + resp);
          console.log('resp status: ' + resp.statusCode);
          if (resp.statusCode == 200) {
              //ok
              resolve(body);
          }
          else {
              reject(resp.scatusCode);
          }
        }
      });
    });
}
/*

node client.js P418e793e714df4027b7c792201f5564ff39a31abe5c344415103cfe37fa964ddKR 오예린 202112230000012
node client.js P510650baff87d5bba02225d030c37bf1b88ce53a50ff74285964ed402957c16aKR 박제민 202112230000013
node client.js P80f5044410c886cb04c68baaa112ea51b4b871ac40fbe5f6a80c9cc22dbd274aKR 모성훈 202112230000014
node client.js Pbfcce6b8936e5fbc7d472749baaf13b470d78565bb02171e2dc99cdcbf4679a2KR 김태연 202112230000015
node client.js P8dee23f54e1fd239613f4234c84445d1fff4fe076119822b5fe3d548c1506817KR 안계혁 202112230000016
node client.js Pc4d0aa731528a38e4fd894de64392639a14db49df752cc474f39d83ceb95c0cfKR 유창욱 202112230000017

*/
/*
select * from TB_KISA_REQ order by idx desc limit 1;
select * from TB_KISA_REQ_BLOB where req_uuid = "";
select * from TB_KISA_RES order by idx desc limit 1;
select * from TB_KISA_RES_BLOB where req_uuid = "";


select * from TB_KISA_REQ left join TB_KISA_REQ_BLOB on TB_KISA_REQ.req_uuid = TB_KISA_REQ_BLOB.req_uuid order by TB_KISA_REQ.idx desc limit 1;
select * from TB_KISA_RES left join TB_KISA_RES_BLOB on TB_KISA_RES.req_uuid = TB_KISA_RES_BLOB.req_uuid order by TB_KISA_RES.idx desc limit 1;
*/