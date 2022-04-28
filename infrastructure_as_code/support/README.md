# Terraform in Docker

This is a small docker image with terraform installed. It has a python click script wrapper that makes it a bit easier to quickly call commands without all the args.

The entrypoint enables a python venv which has all the required python dependencies, after which it runs the command that was sent to the container.