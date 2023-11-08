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
  source      = "git::https://github.com/opz0/terraform-digitalocean-vpc.git?ref=v1.0.0"
  name        = local.name
  environment = local.environment
  region      = local.region
  ip_range    = "10.10.0.0/16"
}

##------------------------------------------------
## Droplet module call
##------------------------------------------------
module "droplet" {
  source        = "git::https://github.com/opz0/terraform-digitalocean-droplet.git?ref=v1.0.0"
  droplet_count = 2
  name          = local.name
  environment   = local.environment
  region        = local.region
  vpc_uuid      = module.vpc.id
  ssh_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD3yaiBTdoamZ1QqIQiekHDc4a9moqtjcsTD4AVcLIY2bEfzEDuHevwTNI/iENFl4ixst92JbrClvAneqNiBj0hNc794lB2jqwqFUnS94qs7xUlKdTyQ1Y7sSbDrPsVi37CURCAGABT7e+oj0sj4tJmj5W36IYDNVqaLJCKKI1s2WOUDGJTdLahzqOZ7AgK1AEXcUM0347Uzgz2aayAy30TiTcqsU+VBvV/EWpVSYT55bdmWTlzyDMNqEPjB7oFa8tTpEOjnm35MxpR+rJwPsYLnefT+OTh0/E7Pjb8HVptgMfAgS3TJt/VMdSe9SDJGew9CXkvPLXy5D4AHk5EfxPy4UZqkU9w2WrXLBzgtIqeox113EMkXNO3Kc8HfEz2FYEPbdWyuHef9tMd+2RhiGwODyNb2/B6ZlE+LM1VH40v3avaPanF8W+t+tatLpZh8vak7+t/8Wk8YmoY/8D3a7VsszIKLSYT+xB7AKcGR+8/6Hbh1b4tfoMjqruhIksfdWM= baldev@baldev"
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
      deny  = "cidr:0.0.0.0/0"
      allow = "cidr:143.244.136.144/32"
    }
  ]
}