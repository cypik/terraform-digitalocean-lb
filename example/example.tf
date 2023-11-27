provider "digitalocean" {}

locals {
  name        = "app"
  environment = "test"
  region      = "blr1"
}

##------------------------------------------------
## VPC module call
##------------------------------------------------
module "vpc" {
  source      = "git::https://github.com/cypik/terraform-digitalocean-vpc.git?ref=v1.0.0"
  name        = local.name
  environment = local.environment
  region      = local.region
  ip_range    = "10.10.0.0/16"
}

##------------------------------------------------
## Droplet module call
##------------------------------------------------
module "droplet" {
  source        = "git::https://github.com/cypik/terraform-digitalocean-droplet.git?ref=v1.0.0"
  droplet_count = 2
  name          = local.name
  environment   = local.environment
  region        = local.region
  vpc_uuid      = module.vpc.id
  ssh_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjrNE0k5e4YOHAUoqffU8u/Yw++wYT2yhIru8e1MfNbimg/NuiVu2rFLZezg7A1q0HcRWfAmTo8TDISAtiyEoy8ZJ6A2mn2bJWQmd5mSixm6J1jBBaYY5FhdVU28KW/GrRxyQD94JtPtMhUGV8FJlm8FJUXgH12Xf8v/dCG/ETG1+u/S22/v+Ph1SjNNdtGoj+Optshts4ukYcXRo2gqtPak6v1TlndLJrKYvs5MPhxR7D6geAQlS9njaiIyjJhxm1wzOFKBu4Pvm2wEYDxgNEfcc14EiRxWMRk1gPdj8srDW1gKRh0BV4nvpTJ9GEyVlxNOzsy5mWkKEpPQyE6kQxMl8znMurJqi8kPCoS9rLrjL/zb2cCLjc2olcuojMc9s3NFfPz75rt8h4CGwKMtuuwRu7xTKiSfBgmhmmv/w7YhI0Y009msq2R/XEDR50QeCkOgGNhDakpR8d0olkUTedzTw3G5LYm4JwBEHrDhHJLeatqCXSZ1HYB/3O3FZdP3E= baldev@baldev"
  user_data     = file("user-data.sh")

  inbound_rules = [
    {
      protocol      = "tcp"
      allowed_ip    = ["0.0.0.0/0"]
      allowed_ports = "22"
    },
    {
      allowed_ip    = ["0.0.0.0/0"]
      allowed_ports = "80"
    }
  ]
}

##------------------------------------------------
## Load Balancer module call
##------------------------------------------------
module "load-balancer" {
  source      = "./../"
  name        = local.name
  environment = local.environment
  region      = local.region
  vpc_uuid    = module.vpc.id
  droplet_ids = module.droplet.id

  enabled_redirect_http_to_https = false
  forwarding_rule = [
    {
      entry_port      = 80
      entry_protocol  = "http"
      target_port     = 80
      target_protocol = "http"
    },
    {
      entry_port       = 443
      entry_protocol   = "http"
      target_port      = 80
      target_protocol  = "http"
      certificate_name = "demo"
    }
  ]

  healthcheck = [
    {
      port                     = 80
      protocol                 = "http"
      check_interval_seconds   = 10
      response_timeout_seconds = 5
      unhealthy_threshold      = 3
      healthy_threshold        = 5
    }
  ]
  sticky_sessions = [
    {
      type               = "cookies"
      cookie_name        = "lb-cookie"
      cookie_ttl_seconds = 300
    }
  ]

  firewall = [
    {
      #      deny  = "cidr:0.0.0.0/0"
      allow = "cidr:0.0.0.0/0"
    }
  ]
}