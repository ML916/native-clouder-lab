variable "platform" {
  description = "The platform where services will be deployed"
  type        = string
}

variable "name" {
  description = "The name of the container"
  type        = string
}

variable "domain" {
  description = "The domain of the container"
  default = ""
  type        = string
}

variable "image" {
  description = "The image to run"
  type        = string
}

variable "location" {
  description = "The location of the container"
  type        = string
  default     = ""
}

variable "project_id" {
  description = "The project id of the platform"
  type        = string
  default     = ""
}

module "container-service-gcp" {
    source = "./gcp"

    count = var.platform == "gcp" ? 1 : 0

    name = var.name
    image = var.image
    project_id = var.project_id
    location = var.location
    domain = var.domain
}

module "container-service-docker" {
    source = "./docker"

    count = var.platform == "docker" ? 1 : 0

    image = var.image
    name = var.name
}

output "url" {
  value = element(compact([
    var.platform == "gcp" ? module.container-service-gcp[0].url : "",
    var.platform == "docker" ? module.container-service-docker[0].url : "",
  ]), 0)
}