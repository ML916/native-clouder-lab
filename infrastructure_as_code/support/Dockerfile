###############################################################################
#
# Download docker images that will be used to extract the required
# binaries to do what is needed.
#
###############################################################################
FROM docker:20.10.12-dind-alpine3.15 as docker
FROM hashicorp/terraform as terraform


###############################################################################
#
# Base docker image
#
# This is the base where all base dependencies are installed. Other images
# will extend from here
#
###############################################################################
FROM python:3-alpine as base

COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
COPY --from=terraform /bin/terraform /bin/terraform

RUN apk add bash


###############################################################################
#
# Build venv with dependencies
#
###############################################################################
FROM python:3-alpine as venv

WORKDIR /app

COPY requirements/requirements.txt /app/requirements/requirements.txt

RUN python -m venv /venv && \
    . /venv/bin/activate && \
    pip install -r /app/requirements/requirements.txt



###############################################################################
#
# Main image
#
# This is the actual image we are using. Doing it this way means that building
# will be much quicker as the previous steps that do not change often are cached.
#
# This image copies what was build and downloaded in the other build steps.
#
###############################################################################
FROM base

WORKDIR /support

COPY --from=venv /venv /venv
COPY . /support
RUN . /venv/bin/activate

ENV SUPPORT_DIR=/support
ENV LABS_DIR=/labs

ENTRYPOINT [ "/support/entrypoint.sh" ]
CMD [ "/support/cli.py" ]