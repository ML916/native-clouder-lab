###############################################################################
#
# Make variable definitions
#
# Quite normal, but one key thing about variable definitions in make is the
# different ways it can be defined.
#
# FOO = bar
# Variables defined with ‘=’ are recursively expanded variables.
#
# FOO ?= bar
# This is a variable with a default, but can be changed by calling
# `make <target> FOO=baz`
#
# FOO := bar
# Variables defined with ‘:=’ or ‘::=’ are simply expanded variables; these
# definitions can contain variable references which will be expanded before
# the definition is made.
#
###############################################################################
DOCKER_IMAGE = "tf-lab"
DOCKER_IMAGE_SERVICE = "tf-lab-service"
PROCESS ?= "050-basics"


###############################################################################
#
# Catch all
#
# This default target is used as a catch all. For the lab, it allows running a
# more simple command which in turn runs the actual run target.
#
# eg: `make 000-something plan` results in calling the run target like this:
# `make run PROCESS=000-something terraform plan`
#
# The block before .DEFAULT is similar to what is explained for the run	target,
# the main difference is that there is no filter for a particular target. This
# will be evaluated for every make invocation.
#
###############################################################################

LAB_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(LAB_ARGS):;@:)

.DEFAULT:
	$(MAKE) run PROCESS=$@ terraform $(LAB_ARGS)

###############################################################################
#
# Build
#
# This command is used to build and prepare everything that is required to
# run or use this lab.
#
###############################################################################
.PHONY: build
build:
	docker pull us-docker.pkg.dev/cloudrun/container/hello
	docker build -t $(DOCKER_IMAGE) support/
	docker build -t $(DOCKER_IMAGE_SERVICE) labs/000-service/

###############################################################################
#
# Debugging
#
# This will start up the container with all labs mounted as a volume debug or
# play around as if it was running on your local machine.
#
###############################################################################
.PHONY: debug
debug: build
	docker run --rm -it \
		-u $(id -u ${USER}):$(id -g ${USER}) \
		-v $(realpath .)/labs:/labs \
		-v $(realpath .)/support:/support \
		$(DOCKER_IMAGE) bash

###############################################################################
#
# Run lab tests
#
# Shamefully this does nothing as I've been really terrible role model and not
# managed to write tests :/. Hopefully I'll be able to remove this embarrassing
# comment in the near future.
#
###############################################################################
.PHONY: test
test: build
	docker run --rm -it \
		-u $(id -u ${USER}):$(id -g ${USER}) \
		-v $(realpath .)/labs:/labs \
		-v $(realpath .)/support:/support \
		-v /tmp/tf-lab-output:/output \
		-v /var/run/docker.sock:/var/run/docker.sock \
		$(DOCKER_IMAGE) pytest


###############################################################################
#
# Run special bulk commands
#
# This is the target for running bulk commands on the service container. The
# bulk commands are mostly to quickly test everything is working or clean up the
# entire project.
#
# The funky ifeq is described on the run target.
#
###############################################################################
ifeq (bulk, $(firstword $(MAKECMDGOALS)))
  BULK_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(BULK_ARGS):;@:)
endif

.PHONY: bulk
bulk: build
	docker run --rm -it \
		-u $(id -u ${USER}):$(id -g ${USER}) \
		-v $(realpath .)/labs:/labs \
		-v $(realpath .)/support:/support \
		-v /tmp/tf-lab-output:/output \
		-v /var/run/docker.sock:/var/run/docker.sock \
		$(DOCKER_IMAGE) python /support/cli.py "bulk-$(BULK_ARGS)"

###############################################################################
#
# Run commands in the support container.
#
# This is the main "entry point" for the labs and running the terraform
# commands.
#
# The first ifeq block is Makefile way of getting arguments sent to make when
# calling the run target specifically. This is kind of like `$@` in bash, `sys.argv`
# in python or `process.argv` in node.js.
#
###############################################################################
ifeq (run, $(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif

.PHONY: run
run: build
	docker run --rm -it \
		-u $(id -u ${USER}):$(id -g ${USER}) \
		-v $(realpath .)/labs:/labs \
		-v $(realpath .)/support:/support \
		-v /tmp/tf-lab-output:/output \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--env GOOGLE_APPLICATION_CREDENTIALS=/gcp.json \
		-v /home/dogmatic69/.google-keys/native-cloud/production.json:/gcp.json \
		--workdir "/labs/$(PROCESS)" \
		$(DOCKER_IMAGE) python /support/cli.py $(RUN_ARGS)