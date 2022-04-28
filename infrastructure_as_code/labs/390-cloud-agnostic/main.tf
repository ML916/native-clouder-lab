// ============================================================================
// NOTE:
//
// At this time, providers can't be in modules with count,
// for_each or depends_on.
// ============================================================================
provider "google-beta" {
  project     = "ingka-native-ikealabs-prod"
  region      = "eu-west3"
  credentials = "/gcp.json"
}

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





/**
 * The holly grail of terraform, completely cloud agnostic terraform
 */
module "docker" {
    source = "./container-service"

    // change platform to deploy somewhere else (eg: gcp, azure, alicloud, docker ....)
    platform   = "docker"
    name       = "hello-world-foo"

    domain = "foobar.com"

    // different platforms do different thigns with image name
    // image = "us-docker.pkg.dev/cloudrun/container/hello"
    image = "vad1mo/hello-world-rest"

    // these are not used in all platforms
    project_id = "my-project"
    location   = "eu-west3"
}
