# <img src="/assets/images/ITOI.png" alt="OpenTelemetry Icon" width="45" height=""> OI Observability Lab
[![operational-intelligence](https://img.shields.io/static/v1?label=oi&message=opi&color=white&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAAv0lEQVQoFX2SWxLDIAhFY6fL0e0lG81+Wg/1MDTTlA/F+wBMbK8ZW4nWWpyEr2elTxN2RHeGyqF9sBAQvfdtjPEBygoGZ/fQO6oV3YsvJ6lcdBSgsqMex5HdweTQEnlHhOd5BmghDuZwaGowbca8S+T7vidWc8Bpjj8Rgn8GOfcvY5ZfFe2C6BphBCRBuCqFjurVXDXhCdUykzuOeMUwG41kAvn1yAk/+6IT85wvJ5i53L0ceffsCGAXciv/wuDfxMQi4xzpAiQAAAAASUVORK5CYII=)](https://github.com/orgs/ingka-group-digital/teams/opi-observability-pipeline)
[![Slack](https://img.shields.io/badge/join%20slack-%23sig--observability-brightgreen.svg)](https://ingka.slack.com/channels/CQ8LHD0KC)

# Part 04: Data Analysis and Distributed Tracing

## Distributed Tracing - understanding your application and it's dependencies

OpenTelemetry supports distributed tracing. This means that the traceid, and relationship between spans and their parents, can be maintained through different applications involved in a transaction. When data is shared the distributed tracing can have a significant impact on understanding and trouble shooting of an application.

In this part of the lab, we will leverage the value of distributed tracing to get a better understanding of dependencies we have in our application and also find the reason for any issues we may experience.

The only direct dependency we have in our application is the xml service. At the time we don't have too much information about how it's operating and what dependencies it has. Let's see what we can find out. The xml service team we kind to let us know that they're also using OpenTelemetry and we're allowed to send data to their OpenTelemetry Collector and analyze at the data in their sink for traces, Jaeger.

All we have to do to start sending the traces is to update our OpenTelemetry Collector configuration, build and deploy. We still want to maintain control of our data so rather than sending the data from our application directly to their OpenTelemetry Collector we will add their OpenTelemetry Collector as an exporter in our configuration.

### OpenTelemetry Collector configuration - sending data to another OpenTelemetry Collector

We'll add an otlphttp exporter, configured with the detail of the xml service OpenTelemetry Collector, to exporters and add it to the traces exporters. We'll keep logging and googlecloud.

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

  otlphttp:
    endpoint: ${XML_OTEL_COLLECTOR_URL}
    headers:
      "Authorization": "Basic bzExeTRldmVyOm8xMXk0ZXZlcg=="

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
      exporters: [logging, googlecloud, otlphttp]
````

### OpenTelemetry Collector configuration - getting more information

Getting our data to Jaeger allowed us to follow a distributed trace through our application and the xml service. The xml service team told us that they, along with other service that may be of interest for us, are using Splunk Observability (former SignalFx) as a sink. We would like to do that as well to  if there is more information available that can give us more insight into the health or our application.

Splunk Observability is having a public trace ingestion endpoint and a token is required to send data. The token must be added as a resource attribute to our traces. We can choose to do that in the application or in the OpenTelemetry Collector by using one of the processors available - resource.

The change we need to do to our OpenTelemetry collector is to add another exporter (``sapm``), a resource and finally add them to our pipeline for traces.

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

  otlphttp:
    endpoint: ${XML_OTEL_COLLECTOR_URL}
    headers:
      "Authorization": "Basic bzExeTRldmVyOm8xMXk0ZXZlcg=="

  sapm:
    access_token_passthrough: true
    endpoint: "https://ingest.eu0.signalfx.com/v2/trace"

processors:

  memory_limiter:
    check_interval: 1s
    limit_percentage: 50
    spike_limit_percentage: 30

  batch:

  resource:
    attributes:
    - key: com.splunk.signalfx.access_token
      value: ${SFX_INGEST_TOKEN}
      action: insert

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
      processors: [memory_limiter, resource, batch]
      exporters: [logging, googlecloud, otlphttp, sapm]
````

