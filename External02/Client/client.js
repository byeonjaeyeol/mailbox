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
    dataJson.data.mi = mi;
    dataJson.data.dr_name = name + "dr";
    dataJson.data.ddj_nm = name;

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
//node client.js P74e4ab5c7965e97d8f4052077da97fd3ea16dbbb17efe3a68a5ffacc1ff4c2f6KR 안계혁 202112090000003
