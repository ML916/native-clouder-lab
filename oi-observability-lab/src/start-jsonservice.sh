#!/bin/bash

/usr/bin/otelcol-contrib --config=/etc/otel-collector/config.yaml &

source /opt/venv/bin/activate &&
python3 /usr/app/src/jsonservice.py
