from waitress import serve

import os
import urllib.request
import base64

import json
import xmltodict

from flask import Flask, render_template, make_response
from flask_httpauth import HTTPBasicAuth

from prometheus_client import start_http_server

from opentelemetry import trace


app = Flask(__name__)
auth = HTTPBasicAuth()

@auth.get_password
def get_password(username):
    if(username == 'o11y4ever'):
        return 'o11y4ever'
    return None

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

      data = json.loads(json_data) 
      if data["items"] == None:
        raise Exception()
        
    except:
      json_data = "{status: \"fail\", message: \"failed to retrieve and parse data from service\"}"
      status = 503

    resp = make_response(json_data)
    resp.headers["Content-type"] = "application/json"
    resp.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    resp.headers["Pragma"] = "no-cache"
    resp.headers["Expires"] = "0"

    return resp, status

@auth.error_handler
def unauthorized():
    return render_template('401.html'), 401

@app.errorhandler(404)
def not_found(error):
    return render_template('404.html'), 404

serve(app, listen='*:8080')
