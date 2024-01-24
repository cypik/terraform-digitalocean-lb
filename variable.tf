variable "name" {
  type        = string
  default     = ""
  description = "The Load Balancer name"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `cypik`,`application`."
}

variable "region" {
  type        = string
  default     = "blr-1"
  description = " The region to start in"
}

variable "size_unit" {
  type        = number
  default     = 1
  description = "The size of the Load Balancer. It must be in the range (1, 100)."
}

variable "lb_size" {
  type        = string
  default     = "lb-small"
  description = "The size of the Load Balancer. It must be either lb-small, lb-medium, or lb-large. Defaults to lb-small. Only one of size or size_unit may be provided."
}

variable "algorithm" {
  type        = string
  default     = "round_robin"
  description = "The load balancing algorithm used to determine which backend Droplet will be selected by a client."
}

variable "enable_proxy_protocol" {
  type        = bool
  default     = false
  description = "A boolean value indicating whether PROXY Protocol should be used to pass information from connecting client requests to the backend service. Default value is false."
}

variable "enable_backend_keepalive" {
  type        = bool
  default     = false
  description = "A boolean value indicating whether HTTP keepalive connections are maintained to target Droplets. Default value is false."
}

variable "http_idle_timeout_seconds" {
  type        = number
  default     = null
  description = "Specifies the idle timeout for HTTPS connections on the load balancer in seconds."
}

variable "project_id" {
  type        = string
  default     = null
  description = "The ID of the project that the load balancer is associated with. If no ID is provided at creation, the load balancer associates with the user's default project."

}

variable "vpc_uuid" {
  type        = string
  default     = ""
  description = " The ID of the VPC where the load balancer will be located."
}

variable "droplet_ids" {
  type        = list(string)
  default     = []
  description = "A list of the IDs of each droplet to be attached to the Load Balancer."
}

variable "droplet_tag" {
  type        = string
  default     = null
  description = "The name of a Droplet tag corresponding to Droplets to be assigned to the Load Balancer."
}

variable "forwarding_rule" {
  type        = list(any)
  default     = []
  description = "A list of forwarding_rule to be assigned to the Load Balancer. The forwarding_rule block is documented below."
}

variable "healthcheck" {
  type        = list(any)
  default     = []
  description = "A healthcheck block to be assigned to the Load Balancer. The healthcheck block is documented below. Only 1 healthcheck is allowed."
}

variable "sticky_sessions" {
  type        = list(any)
  default     = []
  description = "List of objects that represent the configuration of each healthcheck."
}

variable "managedby" {
  type        = string
  default     = "cypik"
  description = "ManagedBy, eg 'cypik'"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether to create the resources. Set to `false` to prevent the module from creating any resources."
}

variable "firewall" {
  type        = list(map(string))
  default     = []
  description = "A block containing rules for allowing/denying traffic to the Load Balancer."
}
variable "enabled_redirect_http_to_https" {
  type    = string
  default = ""
}
