terraform {
  required_version = ">= 0.12"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

variable "namespace" {
  default = ""
}

resource "random_string" "random" {
  length = 6
  upper = false
  number = false
  special = false
  keepers = {
    name = var.namespace
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
  name  = join("-", compact(["hello", "world", random_string.random.result]))
  working_dir = "/app"
}