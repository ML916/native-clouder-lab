# only following on from the bad, usually have one name across all environments for consistency
variable "secret-name" {
    description = "The name of the secret"
    type        = "string"
    default     = "my-secret"
}
variable "secret-version" {
    description = "The version of the secret"
    type        = "string"

    # generally you dont want to pin secrets, requires a redeploy to change
    default     = "latest"
}

variable "concurrency" {
    description = "The number of concurrent requests to make"
    type        = "number"
    default     = 0
}

variable "timeout" {
    description = "The timeout in seconds"
    type        = "number"
    default     = 60
}

variable "environment" {
    description = "The environment to use"
    type        = "string"
    # best to default to prod and accidently use that in dev, over accidently using dev environment in production
    default     = "production"
}

variable "cpu" {
    description = "Amount of cpu"
    type        = "string"
    default     = "200m"
}

variable "memmory" {
    description = "Amount of memory"
    type        = "string"
    default     = "128Mi"
}

variable "bucket-name" {
    description = "The name of the bucket"
    type        = "string"
}
