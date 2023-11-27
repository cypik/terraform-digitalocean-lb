# terraform-digitalocean-load-balancer
# DigitalOcean Terraform Configuration

## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [Examples](#examples)
- [License](#license)

## Introduction
This Terraform configuration is designed to create and manage a DigitalOcean load-balancer.

## Usage
To use this module, you should have Terraform installed and configured for DigitalOcean. This module provides the necessary Terraform configuration for creating DigitalOcean resources, and you can customize the inputs as needed. Below is an example of how to use this module:

#  Example:
You can use this module in your Terraform configuration like this:

```hcl
module "load-balancer" {
  source      = "git::https://github.com/cypik/terraform-digitalocean-load-balancer.git?ref=v1.0.0"
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
      certificate_name = null
    }
  ]
}
```
Please replace "your_database_cluster_id" with the actual ID of your DigitalOcean  lb, and adjust the lb rules as needed.


## Module Inputs

- 'name': The Load Balancer name
- 'region' :  The region to start in
- 'vpc_uuid' : The ID of the VPC where the load balancer will be located.
- 'droplet_ids' : A list of the IDs of each droplet to be attached to the Load Balancer.
- 'forwarding_rule' :  A list of forwarding_rule to be assigned to the Load Balancer. The forwarding_rule block is documented below.
- 'protocol' : The protocol used for health checks sent to the backend Droplets. The possible values are http, https or tcp.
- 'port' : An integer representing the port on the backend Droplets on which the health check will attempt a connection.
- 'target_port' :  An integer representing the port on the backend Droplets to which the Load Balancer will send traffic.
- 'healthcheck' : A healthcheck block to be assigned to the Load Balancer. The healthcheck block is documented below. Only 1 healthcheck is allowed.
- 'sticky_sessions' : A sticky_sessions block to be assigned to the Load Balancer. The sticky_sessions block is documented below. Only 1 sticky_sessions block is allowed.
- 'firewall' : A block containing rules for allowing/denying traffic to the Load Balancer. The firewall block is documented below. Only 1 firewall is allowed.
- 'certificate_name ' :The unique name of the TLS certificate to be used for SSL termination.

## Module Outputs

This module does not produce any outputs. It is primarily used for labeling resources within your Terraform configuration.

- 'id' : The ID of the Load Balancer
- 'ip' : The ip of the Load Balancer
- 'urn'   The uniform resource name for the Load Balancer


## Examples
For detailed examples on how to use this module, please refer to the '[examples](https://github.com/cypik/terraform-digitalocean-lb/blob/master/example)' directory within this repository.

## License
This Terraform module is provided under the '[License Name]' License. Please see the [LICENSE](https://github.com/cypik/terraform-digitalocean-lb/blob/master/LICENSE) file for more details.

## Author
Your Name
Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.
