variable "client_id" {
  description = "Azure client ID"
  type        = string
  sensitive   = true

}

variable "tenant_id" {
  description = "tenant id"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "client secret"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "subscription id"
  type        = string
  sensitive   = true

}
