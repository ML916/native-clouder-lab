const express = require("express");
const products = require("./data/products.json");


const port = 3000;
const app = express();

app.get('/products/:productNumber', (req, res) => {
    const productInfo = products[req.params.productNumber];
    const response = productInfo ?? { message: 'Product not found' };
    const statusCode = productInfo ? 200 : 404;
    res.status(statusCode).send(response);
});

app.listen(port, () => {
    const url = process.env.CLOUD_RUN_SERVICE_URL ?? `http://localhost:${port}`;
    console.log(`product master app running ${url}`)
});
