terraform {
  required_version = ">= 0.12"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "hello" {
  name = "vad1mo/hello-world-rest"
}

resource "docker_container" "foo" {
  image = docker_image.hello.latest
  name  = "hello-world-clean"
  working_dir = "/app"
}