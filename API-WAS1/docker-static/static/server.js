
const express = require('express');
app = express();
const path = require('path')
//global.appRoot = path.resolve(__dirname)
port = process.env.PORT || 8081;
bodyParser = require('body-parser');

app.listen(port, () => {
    console.log('RESTful API server started on: ' + port);
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use('/banner', express.static('storage'));

