# Observability Lab (LAB005) Hand-on Guide
Throughout the lab we will be working with a simple node js app that consists of two services:
- Product Master: A service that provides an api for fetching all information available about a product
- Product Information: A service that is used to fetch and filter products from the Product Master service. This structure is useful in cases where you don't want to crash hard when your external services start failing but instead return a default response.

For instrumenting, generating, collecting, and exporting telemetry data [OpenTelemetry](https://opentelemetry.io/) will be the tool in use.
## Prerequisites
- Docker
- Docker Compose
- Access to a GCP project

## Running the app locally
Before we start talking about observability, let's have a working app that we can run locally without errors and then we will add tracing and metrics data on top of that app.

1. Clone the Native Clouders lab repository
    ```bash
    git clone git@github.com:ingka-group-digital/native-clouders-ikealabs.git
    ```
1. Navigate to the observability lab code folder
    ```bash
    cd native-clouders-ikealabs/labs/observability-lab/code
    ```
1. Now let's run the application and make sure that everything is working fine
    ```bash
    docker-compose up --build
    ```
1. Try sending GET requests to the Product Information service and check if you are getting the responses that you were expecting.
Try calling:
- http://localhost:3002/products/11111110
- http://localhost:3002/products/11111111
- http://localhost:3002/products/x

If everything is working then you can move to the next step.

## Adding tracing to the app
There are several ways of adding trace data to your application, in this lab we will be using the [OpenTelemetry Collector](https://github.com/open-telemetry/opentelemetry-collector) to receive and export trace data.
> The OpenTelemetry Collector offers a vendor-agnostic implementation on how to receive, process and export telemetry data. In addition, it removes the need to run, operate and maintain multiple agents/collectors in order to support open-source telemetry data formats (e.g. Jaeger, Prometheus, etc.) sending to multiple open-source or commercial back-ends.

We will do the following steps in this section of the lab:
- Add [zipkin](https://zipkin.io/) to our local environment
- Set-up the Collector service
- Add tracing to the Product Information API service
- Add tracing to the Product Master service

### Add Zipkin to our local environment
Let us start by adding Zipkin to our local environment. Do that by adding the image `openzipkin/zipkin` to `docker-compose.yml` and export port 9411 so that we can access the Zipkin UI. Now when you bring up the local environment, you should be able to access the Zipkin UI http://localhost:9411/

<details>
<summary>View suggested solution</summary>
Add these lines to <i>docker-compose.yml</i>
<pre>
    <code>
        zipkin:
        image: openzipkin/zipkin:latest
        ports:
            - 9411:9411
    </code>
</pre>
</details>

---

### Set-up the Collector service
We will now create a new service **monitoring** which will contain the needed files to run the Collector.
Start by filling in the config file for the Collector, `otel-collector-config.yaml`. The config can be found in `native-clouders-ikealabs/labs/observability-lab/code/files`.
This is where we are going to tell the Collector:
- from where to receive the trace data
- in what format it should expect the data to be in
- what operations/processors it should apply on the data
- to where it should export the data

---

Use [OTLP Receiver](https://github.com/open-telemetry/opentelemetry-collector/tree/main/receiver/otlpreceiver) (OpenTelemetry Protocol) over HTTP as the receiver. This means that the Collector would be expecting trace data to be sent in an HTTP POST request from the clients (Product Master and Product Information API in our example). This works quite well with Cloud Run which is the reason to why we are picking this specific format for the receiver.

More on the OpenTelemetry Protocol Specification can be found [here](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/otlp.md).

As we are planning to host the Collector as a CLoud Run service later on in this lab, we can have that already in mind when configuring the receiver. Because the container must listen to requests on `0.0.0.0` and by default the requests are sent to port `8080`, configure the endpoint for the OTLP receiver to `0.0.0.0:8080`.

<details>
<summary>View suggested solution</summary>
otel-collector-config.yaml
<pre>
    <code>
        receivers:
            otlp:
                protocols:
                    http:
                        endpoint: "0.0.0.0:8080"
    </code>
</pre>
</details>

---

Now define zipkin in the exporters section of your collector configuration. You can find what endpoint to use by checking the Swagger documentation here https://zipkin.io/zipkin-api/

<details>
<summary>View suggested solution</summary>
otel-collector-config.yaml
<pre>
    <code>
        exporters:
            zipkin:
                endpoint: "http://zipkin:9411/api/v2/spans"
    </code>
</pre>
</details>

---

The final step now is to use the receivers and exporters that we have defined in the Collector config. This is done under the `service` section in the config. You can find how to do this by checking the examples provided by the OpenTelemetry team in the collector repository https://github.com/open-telemetry/opentelemetry-collector

It is also highly recommended to use the [batch processor](https://github.com/open-telemetry/opentelemetry-collector/blob/main/processor/batchprocessor/README.md) on the collector
> The batch processor accepts spans, metrics, or logs and places them into batches. Batching helps better compress the data and reduce the number of outgoing connections required to transmit the data.

<details>
<summary>View suggested solution</summary>
The complete <i>otel-collector-config.yaml</i> should look similar to this
<pre>
    <code>
        receivers:
            otlp:
                protocols:
                    http:
                        endpoint: "0.0.0.0:8080"
        exporters:
            zipkin:
                endpoint: "http://zipkin:9411/api/v2/spans"
        processors:
            batch:
        service:
            pipelines:
                traces:
                    receivers: [otlp]
                    exporters: [zipkin]
                    processors: [batch]
    </code>
</pre>
</details>

---

In docker-hub you will find two types of OpenTelemetry Collector images, `otel/opentelemetry-collector` which contains only the core distribution of the Collector and there is the `otel/opentelemetry-collector-contrib` image which contains vendor specific contribution for the receivers and exporters. You can check what receivers and exporters are available [here](https://github.com/open-telemetry/opentelemetry-collector-contrib).

In most cases you would want to use the contrib image to have a wider range of option. In this part of the lab we want to use Zipkin as the exporter which is why we must use the `otel/opentelemetry-collector-contrib` image.

Update the Dockerfile inside the `monitoring` folder to use that image and copy over the configuration file that was created in the previous step. Now we should be able to use the **config** flag to tell the Collector where to find the config file.

<details>
<summary>View suggested solution</summary>
Dockerfile
<pre>
    <code>
        FROM otel/opentelemetry-collector-contrib:0.29.0
        COPY files/ /
        CMD [ "--config=/otel-collector-config.yaml" ]
    </code>
</pre>
</details>

Now you can add the monitoring service to docker-compose and bring up the project to see if the Collector is starting correctly.

<details>
<summary>View suggested solution</summary>
Add these lines to docker-compose.yml
<pre>
    <code>
         monitoring:
            build: ./monitoring
            depends_on:
            - zipkin
    </code>
</pre>
</details>

---

### Add tracing to the Product Information API service
In this section of the lab we will talk about what dependencies are needed and how to use them to have our service automatically instrument traces and send them to the Collector hosted by our monitoring service.

Let's start by adding the needed dependencies.
- @opentelemetry/sdk-trace-base, @opentelemetry/sdk-node and @opentelemetry/api: these are the core dependencies required to configure the tracing SDK and create spans
- @opentelemetry/exporter-trace-otlp-http: used to send trace data to the Collector
- @opentelemetry/instrumentation, @opentelemetry/instrumentation-http and @opentelemetry/instrumentation-express: autoinstrumentation modules that are used to automatically instrument the http and express modules
- @opentelemetry/resources: used to configure some attributes for the client sending the trace data such as setting the name of the service
All in all you will have to run the following command from within the `product-Information-api` folder:
```bash
yarn add @opentelemetry/exporter-trace-otlp-http \
    @opentelemetry/sdk-trace-node \
    @opentelemetry/sdk-trace-base \
    @opentelemetry/api \
    @opentelemetry/instrumentation \
    @opentelemetry/instrumentation-http \
    @opentelemetry/instrumentation-express \
    @opentelemetry/resources
```


### Add tracing to the Product Master service
TODO
