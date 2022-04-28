const { initTracer } = require('./lib/monitoring');
const { PRODUCT_MASTER_BASE_URL, COLLECTOR_URL } = process.env;
initTracer(COLLECTOR_URL, 'Product Information');

const express = require("express");
const fetch = require('node-fetch');


const getProductInformation = async (productNumber) => {
    const endpoint = `${PRODUCT_MASTER_BASE_URL}/products/${productNumber}`;

    try {
        const response = await fetch(endpoint);

        if (response.status === 200) {
            const body = await response.json();
            return {
                name: body.name,
                description: body.description,
            };
        }
    } catch {
        // silently do nothing
    }

    return {
        name: 'unknown',
        description: 'unknown',
    };
};


const port = 3000;
const app = express();

app.get('/products/:productNumber', async (req, res) => {
    const { productNumber } = req.params;

    const isValidProductNumber = /^\d{8}$/.test(productNumber);
    if (!isValidProductNumber) {
        return res.status(400).send(`${productNumber} is not a valid product number`);
    };

    const productInfo = await getProductInformation(productNumber);
    return res.status(200).send(productInfo);
});

app.listen(port, () => {
    const url = process.env.CLOUD_RUN_SERVICE_URL ?? `http://localhost:${port}`;
    console.log(`product master app running ${url}`)
});
