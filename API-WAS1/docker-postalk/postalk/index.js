const helmet = require('helmet')
const express = require('express')
const router = require('./router/api.js')
const path = require('path')
const fs = require('fs');
const http = require("http");
const app = express()
var PORT
if(process.env.NODE_ENV === 'production'){
  PORT = 8080
} else if(process.env.NODE_ENV === 'dev'){
  PORT = 4000
} else if(process.env.NODE_ENV === 'test'){
  PORT = 8080
} else {
  PORT = 8080
}

global.appRoot = path.resolve(__dirname)
global.uploadDir = path.resolve(__dirname, 'upload')

app.use(helmet())
app.use(express.urlencoded({ extended: false }))
app.use(express.json())
app.use('/api', router)
app.use(express.static('public'))
app.use('/user', express.static('public_user'))
//app.use('/banner', express.static('storage'));  //addd banner

app.get('/user*', function (req, res) {
  res.sendFile(path.resolve(global.appRoot, 'public_user/index.html'))
})

//add banner function
//get image resource from remote server
var imgPath;
app.get('/banner*', function (req, res) {
  var mime = require('mime');
  //todo active
  //var imgPath = "http://10.64.203.122:8081"+req.url;
  //for dev
  //var imgPath = "http://localhost:8081"+req.url;
  //  var imgPath = "http://static:8081"+req.url;
    if(process.env.NODE_ENV === 'production'){
        imgPath = "http://10.64.203.122:8081"+req.url;
    } else if(process.env.NODE_ENV === 'dev'){
        imgPath = "http://localhost:8081"+req.url;
    } else if(process.env.NODE_ENV === 'test'){
        imgPath = "http://static:8081"+req.url;
    } else {
        imgPath = "http://static:8081"+req.url;
    }

  var imgMime = mime.getType(req.url);

  req.pipe(
       http.get(imgPath, response => {
         res.writeHead(200, {"Content-Type": imgMime});
         response.pipe(res);
       })
  )

})


app.get('*', function (req, res) {
  res.sendFile(path.resolve(global.appRoot, 'public/index.html'))
})

app.listen(PORT, '0.0.0.0', function () {
  console.log(`http://localhost:${PORT} running!!`)
})
