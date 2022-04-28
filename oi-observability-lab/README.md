# <img src="/assets/images/ITOI.png" alt="OpenTelemetry Icon" width="45" height=""> OI Observability Lab
[![operational-intelligence](https://img.shields.io/static/v1?label=oi&message=opi&color=white&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAAv0lEQVQoFX2SWxLDIAhFY6fL0e0lG81+Wg/1MDTTlA/F+wBMbK8ZW4nWWpyEr2elTxN2RHeGyqF9sBAQvfdtjPEBygoGZ/fQO6oV3YsvJ6lcdBSgsqMex5HdweTQEnlHhOd5BmghDuZwaGowbca8S+T7vidWc8Bpjj8Rgn8GOfcvY5ZfFe2C6BphBCRBuCqFjurVXDXhCdUykzuOeMUwG41kAvn1yAk/+6IT85wvJ5i53L0ceffsCGAXciv/wuDfxMQi4xzpAiQAAAAASUVORK5CYII=)](https://github.com/orgs/ingka-group-digital/teams/opi-observability-pipeline)
[![Slack](https://img.shields.io/badge/join%20slack-%23sig--observability-brightgreen.svg)](https://ingka.slack.com/channels/CQ8LHD0KC)


* Part 1 - OpenTelemetry Instrumentation
  * Locally test application with docker compose
  * Locally instrument application with OpenTelemetry (auto)
  * Verify traces in otel collector (logging exporter)
  * Locally instrument application with OpenTelemeetry (manual)
  * Verify traces in otel collector (logging exporter)


* Part 2 - Build and Deploy
  * Build containers to artifact registry using cloud build
  * Deploy to Cloud Run using Terraform
  * Verify traces in otel collector in Cloud Run (logging exporter still enabled)


* Part 3 - The OpenTelemetry Collector
  * Configure the collector to send traces to GCP Trace
  * Looking into the tracing data from our application


* Part 4 - Analyze and Distributed Tracing
  * Analyze the issue by looking at the traces
  * Configure the collector to send traces to GCP Trace and Jaeger
  * Configure the collector to send traces to GCP Trace, Jaeger and SignalFx

## Links

- Project homepage: https://github.com/ingka-group-digital/oi-o11y-native-clouders-oi-lab
- Repository: https://github.com/ingka-group-digital/oi-o11y-native-clouders-oi-lab
- Issue tracker: https://github.com/ingka-group-digital/oi-o11y-native-clouders-oi-lab/issues
- Slack Channel: https://ingka.slack.com/archives/CQ8LHD0KC
- Related projects:
  - O11y Core Config: https://github.com/ingka-group-digital/oi-o11y-core-config
  - CNCF OpenTelemetry: https://github.com/open-telemetry
