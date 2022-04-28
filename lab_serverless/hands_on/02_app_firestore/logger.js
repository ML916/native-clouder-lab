/*
The code below is part of an IKEALab exercise, its written for teaching engineers some specific lessons using different cloud providers. therefore, no code on this ikealab should  be used in any other environment than this one.
*/

const express = require('express');
const app = module.exports = express();
const port = 8080;
const https = require('https');
const bodyParser = require('body-parser');
const pkg = require('./package.json');
const apiPrefix = '/api';
const winston = require('winston')
const {LoggingWinston} = require('@google-cloud/logging-winston');


const loggingWinston = new LoggingWinston();

// Create a Winston logger that streams to Stackdriver Logging
// Logs will be written to: "projects/YOUR_PROJECT_ID/logs/winston_log"
const logger = winston.createLogger({
  level: 'info',
  transports: [
    new winston.transports.Console(),
    // Add Stackdriver Logging
    loggingWinston,
  ],
});

// Writes some log entries
//logger.error('warp nacelles offline');
//logger.info('shields at 99%');