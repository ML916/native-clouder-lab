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


const api_key = process.env.API_KEY;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


// Configure routes
const router = express.Router();

router.post('/product/availability', (req, res) => {
  if (res.statusCode = 400) {
    logger.error('400 error from /api/product/availability')
  }
  logger.info(`request payload : ${req.body}` )
  if (req.body.api_key != api_key) {
    return res.status(400).json({ error: 'Wrong API KEY !' });
  }
  if (!req.body.product_name){
    return res.status(400).json({ error: 'Missing parameters' });
  }
  else{
      fetchFromFirestore(req.body.product_name)
      .then(response => {
        logger.info(`function call output : ${response}`)
        return res.json({"responseBody": response});
      })
      .catch((error) => logger.error(error));
  }

  
});

async function fetchFromFirestore(product_name) {
  var firestoreLib = require("firebase-admin");
  if(!firestoreLib.apps.length){
    firestoreLib.initializeApp({
      credential: firestoreLib.credential.applicationDefault(),
      databaseURL: "https://ingka-native-ikealabs-dev.firebaseio.com"
    });
  }
  
  let prod_avail = "PRODUCT NOT FOUND !"
  const firestore_db = firestoreLib.firestore();
  let product_collection = firestore_db.collection('serverlesslab_product');
  var collectionResult = await getDbData (product_collection, product_name)
  if (collectionResult) {
    console.log("Product found !")
    collectionResult.forEach(document => {
      console.log(document.data().product_availability)
      prod_avail = document.data().product_availability
    })
    
    return prod_avail
  }
  else {
    console.log("Product NOT found !")
    return prod_avail
  }
}

async function getDbData (product_collection, product_name) {
  var product_value = await product_collection.where("product_name", "==", product_name).get()
  return product_value
}



app.use(apiPrefix, router);


// 500 error handling
app.use((err, req, res, next) => {
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