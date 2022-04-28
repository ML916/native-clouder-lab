#!/bin/bash

/usr/bin/otelcol-contrib --config=/etc/otel-collector/config.yaml &

source /opt/venv/bin/activate &&
export OTEL_TRACES_EXPORTER=otlp &&
export OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4317" &&
export OTEL_RESOURCE_ATTRIBUTES="legalCompany=ingka,systemName=NativeClouders,service.name=jsonservice,environment=oi-o11y-lab" &&
opentelemetry-instrument python3 /usr/app/src/jsonservice.py
