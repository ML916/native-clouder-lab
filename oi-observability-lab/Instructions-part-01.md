# <img src="/assets/images/ITOI.png" alt="OpenTelemetry Icon" width="45" height=""> OI Observability Lab
[![operational-intelligence](https://img.shields.io/static/v1?label=oi&message=opi&color=white&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAAv0lEQVQoFX2SWxLDIAhFY6fL0e0lG81+Wg/1MDTTlA/F+wBMbK8ZW4nWWpyEr2elTxN2RHeGyqF9sBAQvfdtjPEBygoGZ/fQO6oV3YsvJ6lcdBSgsqMex5HdweTQEnlHhOd5BmghDuZwaGowbca8S+T7vidWc8Bpjj8Rgn8GOfcvY5ZfFe2C6BphBCRBuCqFjurVXDXhCdUykzuOeMUwG41kAvn1yAk/+6IT85wvJ5i53L0ceffsCGAXciv/wuDfxMQi4xzpAiQAAAAASUVORK5CYII=)](https://github.com/orgs/ingka-group-digital/teams/opi-observability-pipeline)
[![Slack](https://img.shields.io/badge/join%20slack-%23sig--observability-brightgreen.svg)](https://ingka.slack.com/channels/CQ8LHD0KC)

# Part 01: OpenTelemetry Instrumentation

## OpenTelemetry

### About

OpenTelemetry is a collection of tools, APIs, and SDKs. Use it to instrument, generate, collect, and export telemetry data (metrics, logs, and traces) to help you analyze your software’s performance and behavior. OpenTelemetry is generally available across several languages.

### Auto and manual instrumentation

One of the easiest ways to instrument applications is to use OpenTelemetry automatic instrumentation (auto-instrumentation). This approach is simple, easy, and doesn’t require many code changes. You typically only need to install a few packages to successfully instrument your application’s code. The auto-instrumentation does not cover all functions and methods and most likely there will be situation where it needs to be complemented with manual instrumentation.

## The application

The application in this lab is a simple Python Flask application that transforms data from a xml service into json. We will instrument it with OpenTelemetry to understand how the different parts of the application is operating and performing.

### Adding auto-instrumentation

To enable auto-instrumentation in Python we will need to add a few packages and environment variables to our application.

Open _requirements-jsonservice.txt_. Add the OpenTelemetry the core packages.
````python
opentelemetry-distro==0.28b1
opentelemetry-api==1.9.1
opentelemetry-sdk==1.9.1
opentelemetry-exporter-otlp-proto-grpc==1.9.1
````

To get and install auto-instrumentation packages that we need we will run the opentelemetry-bootstrap. We need to update our container to run it prior to running our application. Update the _Dockerfile.jsonservice_ per below.

````dockerfile
COPY ./src/requirements-jsonservice.txt .
RUN . /opt/venv/bin/activate \
    && pip install --upgrade pip \
    && pip install -r requirements-jsonservice.txt \
    && opentelemetry-bootstrap --action=install
````

To export the traces and set desired resource attributes we'll need to set a few environment variables prior to running our application. Finally, we also need to run it with the opentelemetry-instrument command. The instrument command will try to automatically detect packages used by your python program and when possible, apply automatic tracing instrumentation on them. This means your program will get automatic distributed tracing without having to make any code changes at all. You will need to ensure the following code matches _src/start-jsonservice.sh_ Change "\<USER>" to your username.
    
````shell
source /opt/venv/bin/activate &&
export OTEL_TRACES_EXPORTER=otlp &&
export OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4317" &&
export OTEL_RESOURCE_ATTRIBUTES="legalCompany=ingka,systemName=NativeClouders,service.name=<USER>-jsonservice,environment=oi-o11y-lab" &&
opentelemetry-instrument python3 /usr/app/src/jsonservice.py
````

### Adding manual instrumentation

The auto-instrumentation may need to be complemented with manual instrumentation if a function or method is not covered. The manual instrumentation adds full flexibility but does require code changes. In our application we'd like to know how long it takes to parse the xml (``xmltodict.parse``) and create the json ``(json.dumps``). Edit _src/jsonservice.py_ to match the code below:

````python
:
from opentelemetry import trace
:
:
@app.route('/getjson')
@auth.login_required
def getitems():

    tracer = trace.get_tracer(__name__)
    status = 200

    try:
      url = os.environ["XML_SERVICE_URL"]
        
      request = urllib.request.Request(url)
      base64string =  base64.b64encode(bytes('%s:%s' % ('o11y4ever', 'o11y4ever'), 'ascii'))
      request.add_header("Authorization", "Basic %s" % base64string.decode('utf-8'))   
      result = urllib.request.urlopen(request)

      myfile = result.read()

      with tracer.start_as_current_span("parse xml") as span:
        data_dict = xmltodict.parse(myfile)
      with tracer.start_as_current_span("create json") as span:
        json_data = json.dumps(data_dict)

:
:
````

Once the application is instrumented it will send OpenTelemetry traces to the OpenTelemetry collector. An easy way to verify that everything is working as expected is to use the logging exporter of the OpenTelemetry collector and verify that traces are received.

The application package you have received includes a docker-compose file that allows you to run the application and the OpenTelemetry collector containers locally. That can be used to quickly verify the instrumentation.
