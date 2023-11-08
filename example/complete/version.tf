terraform {
  required_version = ">= 1.4.6"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.31.0"
    }
  }
}