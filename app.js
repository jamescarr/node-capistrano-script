
/**
 * Module dependencies.
 */

var express = require('express');

var app = module.exports = express.createServer();

app.get('/', function(req, res){
  res.send('Hello from my app');
});

app.listen(3000);
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
