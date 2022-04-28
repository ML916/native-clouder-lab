terraform {
  required_version = ">= 0.12"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

variable "image" {

}

variable "name" {

}
variable "domain" {

}

variable "internal-port" {
  default = 5050
}

variable "extermal-port" {
  default = 5050
}

resource "null_resource" "example2" {
  provisioner "local-exec" {
    command = "cat \"127.0.0.1 ${var.domain}\"" >> /etc/hosts"
  }
}

resource "docker_container" "hello-world" {
  image       = var.image
  name        = var.name
  working_dir = "/app"

  ports {
    internal = var.internal-port
    external = var.extermal-port
  }

  env = [
      "PORT=${var.internal-port}",
      "NAME=${var.name}",
      "IMAGE=${var.image}",
      "PROJECT_ID=",
  ]
}

output "id" {
  value = docker_container.hello-world.id
}

output "name" {
  value = var.name
}

output "url" {
  value = "http://127.0.0.1:${var.extermal-port}"
}