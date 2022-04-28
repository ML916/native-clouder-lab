const { NodeTracerProvider } = require('@opentelemetry/sdk-trace-node');
const { SimpleSpanProcessor } = require('@opentelemetry/sdk-trace-base');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-http');
const { registerInstrumentations } = require('@opentelemetry/instrumentation');
const { Resource } = require('@opentelemetry/resources');
const { HttpInstrumentation } = require('@opentelemetry/instrumentation-http');
const { ExpressInstrumentation } = require('@opentelemetry/instrumentation-express');


const initTracer = (collectorUrl, serviceName) => {
    /* TODO
        - Create a node tracer provider
        - Configure the service name to the name sent in the method arguments
        - Register instrumentation for HTTP and Express modules
        - Create an OTLP exporter and configure it to send trace data to the collector url from the arguments
        - Add the exporter to the provider and register the provider
    */
};

module.exports = {
    initTracer,
};
