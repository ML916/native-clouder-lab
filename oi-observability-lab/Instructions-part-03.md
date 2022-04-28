# <img src="/assets/images/ITOI.png" alt="OpenTelemetry Icon" width="45" height=""> OI Observability Lab
[![operational-intelligence](https://img.shields.io/static/v1?label=oi&message=opi&color=white&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAAv0lEQVQoFX2SWxLDIAhFY6fL0e0lG81+Wg/1MDTTlA/F+wBMbK8ZW4nWWpyEr2elTxN2RHeGyqF9sBAQvfdtjPEBygoGZ/fQO6oV3YsvJ6lcdBSgsqMex5HdweTQEnlHhOd5BmghDuZwaGowbca8S+T7vidWc8Bpjj8Rgn8GOfcvY5ZfFe2C6BphBCRBuCqFjurVXDXhCdUykzuOeMUwG41kAvn1yAk/+6IT85wvJ5i53L0ceffsCGAXciv/wuDfxMQi4xzpAiQAAAAASUVORK5CYII=)](https://github.com/orgs/ingka-group-digital/teams/opi-observability-pipeline)
[![Slack](https://img.shields.io/badge/join%20slack-%23sig--observability-brightgreen.svg)](https://ingka.slack.com/channels/CQ8LHD0KC)

# Part 03: Configure the OpenTelemetry Collector

## Exporting signals - the power of sharing

The OpenTelemetry Collector, on a high level, contains of the different components, receivers, processors, and exporters. The receivers are the input, processors can make various data operations, and the exporters are the output. When we instrumented our application in the first part of this lab, we were only sending the traces to the logging exporter. While it's a good way to verify that traces, and other signals, are coming through the pipeline, it's hardly an efficient way to consume the data. Now is the time to leverage the export capability of the OpenTelemetry Collector. The exports are operating as "fan out", which means that the same data can be sent to multiple exporters and consumed by multiple teams. This is key when it comes to distributed tracing and observability in a modern IT landscape.

In this part of the lab, we will add one more exporter to our OpenTelemetry Collector. Since we're operating in GCP, we will try out the trace sink (Trace) in GCP. To enable it we will need to add the specification of the exporter to our OpenTelemetry Collector and add it to our trace pipeline. We will keep the logging exporter for now, since it's a good way to verify that our traces are properly reaching the OpenTelemetry Collector.

### OpenTelemetry Collector configuration

We'll add googlecloud to exporters and add it to the traces exporters. Configure _otel-collector-config-jsonservice-cloudrun.yaml_ to match the following:

````yaml
---
receivers:

  otlp:
    protocols:
      grpc:
      http:
        auth:
          authenticator: basicauth

exporters:
 
  logging:
    loglevel: debug
    sampling_initial: 5
    sampling_thereafter: 200

  googlecloud:
    project: ${GCP_PROJECT}

processors:

  memory_limiter:
    check_interval: 1s
    limit_percentage: 50
    spike_limit_percentage: 30

  batch:

extensions:
  health_check:
  memory_ballast:
    size_in_percentage: 40
  basicauth:
    htpasswd: 
      inline: |
        o11y4ever:o11y4ever
service:

  extensions: [health_check, basicauth]

  pipelines:

    traces:
      receivers: [otlp]
      processors: [memory_limiter, batch]
      exporters: [logging, googlecloud]
````
