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
app.use(express.json())




const winston = require('winston')
const {LoggingWinston} = require('@google-cloud/logging-winston');
const e = require('express');
const loggingWinston = new LoggingWinston();
// Create a Winston logger that streams to Stackdriver Logging
const logger = winston.createLogger({
  level: 'info',
  transports: [
    new winston.transports.Console(),
    // Add Stackdriver Logging
    loggingWinston,
  ],
});
logger.info('test info')
logger.error('test error')




app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


// Configure routes 
const router = express.Router();

router.post('/product/ingestion/firestore', (req, res) => {

    var productInfoPubSub = decodeBase64Json(req.body.message.data);

    logger.info(productInfoPubSub);
    if (!productInfoPubSub.product_name || !productInfoPubSub.product_availability) {
      logger.error("Error occured, Check Msg Body ! ")
      return res.status(200).send();
    } else {
      logger.info(productInfoPubSub.product_name)
      logger.info(productInfoPubSub.product_availability)
    }


    var firestoreLib = require("firebase-admin");
    if (!firestoreLib.apps.length) {
      firestoreLib.initializeApp({
        credential: firestoreLib.credential.applicationDefault(),
        databaseURL: "https://ingka-native-ikealabs-dev.firebaseio.com"
      });
    }
    const firestore_db = firestoreLib.firestore();
    let product_collection = firestore_db.collection('serverlesslab_product');
    let productInfo = {
      product_name: productInfoPubSub.product_name,
      product_availability: productInfoPubSub.product_availability
    }

    product_collection.add(productInfo);
    logger.info("Msg pushed in firestore")
    res.status(200).send();

});

function decodeBase64Json(data){
  return JSON.parse(Buffer.from(data, 'base64').toString('utf-8'));
}







app.use(apiPrefix, router);


// 500 error handling
app.use((err, req, res, next) => {
  logger.error(err.message);
  res.status(err.status || 500);
  res.send({ error: err.message });
})

// 404 error handling
app.use((req, res) => {
  res.status(404);
  res.send({ error: "not found!" });
})

// app listen start
app.listen(port, () => {
  console.log(`ikea lab app listening on port ${port}`)
})