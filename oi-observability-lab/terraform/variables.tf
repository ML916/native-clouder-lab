# GCP Build Variables
# Everything you should ever need to change should be in this file
variable "user" {
  description = "Name of the user running tf."
  default     = "<USER>"
}

variable "provider_project" {
  description = "Name of project."
  default     = "<PROVIDER_PROJECT>"
}

variable "provider_region" {
  description = "Project region."
  default     = "europe-west4"
}

variable "provider_zone" {
  description = "Default project zone."
  default     = "europe-west4-a"
}
variable "project_name" {
  description = "Project name to be inherited by created resources"
  default     = "oi-o11y-native-clouders-oi-lab"
}


variable "json_service_image" {
  description = "Image to use for json service"
  default     = "jsonservice"
}

variable "json_collector_image" {
  description = "Image to use for json collector"
  default     = "otelcollectorjson"
}

variable "xml_otel_collector_url" {
  description = "Url to itoi OTelCol"
  default = "https://otel-collector.itoi.dev"
  
}
