# <img src="/assets/images/ITOI.png" alt="OpenTelemetry Icon" width="45" height=""> OI Observability Lab Instructions 00
[![operational-intelligence](https://img.shields.io/static/v1?label=oi&message=opi&color=white&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAAv0lEQVQoFX2SWxLDIAhFY6fL0e0lG81+Wg/1MDTTlA/F+wBMbK8ZW4nWWpyEr2elTxN2RHeGyqF9sBAQvfdtjPEBygoGZ/fQO6oV3YsvJ6lcdBSgsqMex5HdweTQEnlHhOd5BmghDuZwaGowbca8S+T7vidWc8Bpjj8Rgn8GOfcvY5ZfFe2C6BphBCRBuCqFjurVXDXhCdUykzuOeMUwG41kAvn1yAk/+6IT85wvJ5i53L0ceffsCGAXciv/wuDfxMQi4xzpAiQAAAAASUVORK5CYII=)](https://github.com/orgs/ingka-group-digital/teams/opi-observability-pipeline)
[![Slack](https://img.shields.io/badge/join%20slack-%23sig--observability-brightgreen.svg)](https://ingka.slack.com/channels/CQ8LHD0KC)


## Getting started

### Setting up the GCP Cloud Shell Environment

Make sure to select the correct project in the menu. ingka-native-ikealabs-dev


```
gcloud config set project ingka-native-ikealabs-dev
```
You may be prompted to authorize the cloud shell session. When completed you should see the following prompt:
```
Updated property [core/project].
user@cloudshell:~ (ingka-native-ikealabs-dev)$
```

### Ensure you have the correct version of Docker Compose

Remove the old docker-compose, if installed.
```
sudo apt-get remove docker-compose
```

Get the latest version number as an env var.
```
VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
```

Download and install the latest version.
```
DESTINATION=/usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
sudo chmod 755 $DESTINATION
```

### Fork the project into your own Git Repo
You will need a copy in your own git repo for working with Cloud Build
```
https://github.com/ingka-group-digital/native-clouders-ikealabs
```


### Clone the project into your Cloud Shell environment

Clone the repo in your Cloud Shell home directory:

```
git@github.com:ingka-group-digital/native-clouders-ikealabs.git
```

Change directory into the OI Observability Lab directory
```
cd native-clouders-ikealabs/labs/oi-observability-lab/
```

Inside the _oi-observability-lab directory_ directory the _src/_ directory contains our test python application, _cloudbuild_ contains the yaml files for Cloud Build, and the _terraform_ directory contains the infrastructure code for deploying our apps in the cloud.

Congrationations! You are now ready to begin the OI O11y Lab!


