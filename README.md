# Terraform-digitalocean-load-balancer
# Terraform DigitalOcean cloud load-balancer Module


## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [Author](#author)
- [License](#license)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This Terraform configuration is designed to create and manage a DigitalOcean load-balancer.

## Usage
To use this module, you should have Terraform installed and configured for DigitalOcean. This module provides the necessary Terraform configuration for creating DigitalOcean resources, and you can customize the inputs as needed. Below is an example of how to use this module:


```hcl

module "load-balancer" {
  source      = "cypik/load-balancer/digitalocean"
  version     = "1.0.1"
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


## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/cypik/terraform-digitalocean-lb/blob/master/example) directory within this repository.

## Author
Your Name Replace **MIT** and **cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This Terraform module is provided under the **MIT** License. Please see the [LICENSE](https://github.com/cypik/terraform-digitalocean-lb/blob/master/LICENSE) file for more details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | >= 2.34.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | >= 2.34.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/digitalocean | 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [digitalocean_loadbalancer.main](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/loadbalancer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_algorithm"></a> [algorithm](#input\_algorithm) | The load balancing algorithm used to determine which backend Droplet will be selected by a client. | `string` | `"round_robin"` | no |
| <a name="input_disable_lets_encrypt_dns_records"></a> [disable\_lets\_encrypt\_dns\_records](#input\_disable\_lets\_encrypt\_dns\_records) | A boolean value indicating whether to disable automatic DNS record creation for Let's Encrypt certificates that are added to the load balancer. Default value is false. | `bool` | `false` | no |
| <a name="input_droplet_ids"></a> [droplet\_ids](#input\_droplet\_ids) | A list of the IDs of each droplet to be attached to the Load Balancer. | `list(string)` | `[]` | no |
| <a name="input_droplet_tag"></a> [droplet\_tag](#input\_droplet\_tag) | The name of a Droplet tag corresponding to Droplets to be assigned to the Load Balancer. | `string` | `null` | no |
| <a name="input_enable_backend_keepalive"></a> [enable\_backend\_keepalive](#input\_enable\_backend\_keepalive) | A boolean value indicating whether HTTP keepalive connections are maintained to target Droplets. Default value is false. | `bool` | `false` | no |
| <a name="input_enable_proxy_protocol"></a> [enable\_proxy\_protocol](#input\_enable\_proxy\_protocol) | A boolean value indicating whether PROXY Protocol should be used to pass information from connecting client requests to the backend service. Default value is false. | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether to create the resources. Set to `false` to prevent the module from creating any resources. | `bool` | `true` | no |
| <a name="input_enabled_redirect_http_to_https"></a> [enabled\_redirect\_http\_to\_https](#input\_enabled\_redirect\_http\_to\_https) | n/a | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | A block containing rules for allowing/denying traffic to the Load Balancer. | `list(map(string))` | `[]` | no |
| <a name="input_forwarding_rule"></a> [forwarding\_rule](#input\_forwarding\_rule) | A list of forwarding\_rule to be assigned to the Load Balancer. The forwarding\_rule block is documented below. | `list(any)` | `[]` | no |
| <a name="input_healthcheck"></a> [healthcheck](#input\_healthcheck) | A healthcheck block to be assigned to the Load Balancer. The healthcheck block is documented below. Only 1 healthcheck is allowed. | `list(any)` | `[]` | no |
| <a name="input_http_idle_timeout_seconds"></a> [http\_idle\_timeout\_seconds](#input\_http\_idle\_timeout\_seconds) | Specifies the idle timeout for HTTPS connections on the load balancer in seconds. | `number` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `cypik`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_lb_size"></a> [lb\_size](#input\_lb\_size) | The size of the Load Balancer. It must be either lb-small, lb-medium, or lb-large. Defaults to lb-small. Only one of size or size\_unit may be provided. | `string` | `"lb-small"` | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'cypik' | `string` | `"cypik"` | no |
| <a name="input_name"></a> [name](#input\_name) | The Load Balancer name | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project that the load balancer is associated with. If no ID is provided at creation, the load balancer associates with the user's default project. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to start in | `string` | `"blr-1"` | no |
| <a name="input_size_unit"></a> [size\_unit](#input\_size\_unit) | The size of the Load Balancer. It must be in the range (1, 100). | `number` | `1` | no |
| <a name="input_sticky_sessions"></a> [sticky\_sessions](#input\_sticky\_sessions) | List of objects that represent the configuration of each healthcheck. | `list(any)` | `[]` | no |
| <a name="input_vpc_uuid"></a> [vpc\_uuid](#input\_vpc\_uuid) | The ID of the VPC where the load balancer will be located. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Load Balancer |
| <a name="output_ip"></a> [ip](#output\_ip) | The ip of the Load Balancer |
| <a name="output_urn"></a> [urn](#output\_urn) | The uniform resource name for the Load Balancer |
<!-- END_TF_DOCS -->