const { NodeTracerProvider } = require('@opentelemetry/sdk-trace-node');
const { SimpleSpanProcessor } = require('@opentelemetry/sdk-trace-base');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-http');
const { registerInstrumentations } = require('@opentelemetry/instrumentation');
const { Resource } = require('@opentelemetry/resources');
const { HttpInstrumentation } = require('@opentelemetry/instrumentation-http');
const { ExpressInstrumentation } = require('@opentelemetry/instrumentation-express');


const initTracer = (collectorUrl, serviceName) => {
    const exporter = new OTLPTraceExporter({
        url: new URL('/v1/traces', collectorUrl).toString(),
    });

    const provider = new NodeTracerProvider({
        resource: Resource.default().merge(
            new Resource({
                'service.name': serviceName,
            }),
        ),
    });
    registerInstrumentations({
        instrumentations: [
            new HttpInstrumentation(),
            new ExpressInstrumentation(),
        ],
    });
    provider.addSpanProcessor(new SimpleSpanProcessor(exporter));
    provider.register();
};

module.exports = {
    initTracer,
};
