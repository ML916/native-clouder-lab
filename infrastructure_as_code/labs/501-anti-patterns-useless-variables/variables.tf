
variable "environment" {
    description = "The environment to use"
    type        = "string"
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

// These are ok depending on context

variable "secret-name" {
    // ok for a reusable service that might conflict with other secret names
    description = "The name of the secret"
    type        = "string"
    default     = "my-secret"
}
variable "secret-version" {
    // generally you dont want to pin secrets, requires a redeploy to change making it hard to rotate
    description = "The version of the secret"
    type        = "string"
    default     = "latest"
}

variable "concurrency" {
    // ok in a reusable module for a generic cloud run service,
    // otherwise you want consistency across environments
    description = "The number of concurrent requests to make"
    type        = "number"
    default     = 0
}

variable "timeout" {
    // as with concurrency
    description = "The timeout in seconds"
    type        = "number"
    default     = 60
}


// These are bad
variable "location" {
    // why would dev / prod be in different locations
    description = "The location of the bucket"
    type        = "string"
}

variable "environment-variable-name" {
    // if the name is changing, the code will have to be changed to match,
    // even more complexity to handle differences across environments
    description = "The name of the environment variable"
    type        = "string"
}

variable "command" {
    // why would the command change, completely different service would be deployed :O
    description = "The command to run"
    type        = "string"
}