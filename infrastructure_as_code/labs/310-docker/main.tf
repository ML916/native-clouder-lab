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

resource "docker_container" "hello-world" {
  image       = "vad1mo/hello-world-rest@sha256:9172f33d9910a44e60d1c67dd4f6792d181e80aa356b66bb2f1d0aff8b2a9f5a"
  name        = "hello-world"
  shm_size    = 64
  // working_dir = "/app"


  ports {
    internal = 5050
    external = 5060
  }
}

