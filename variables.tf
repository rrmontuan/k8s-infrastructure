variable "region" {
  description = "AWS Region"
}

variable "access_key" {
  description = "The access key from the user used to manage resources"
}

variable "secret_key" {
  description = "The secret key from the user used to manage resources"
}

variable "public_key" {
  description = "the Public key that will be registered with AWS to allow logging-in to EC2 Instances"
}

variable "domain" {
  description = "The Domain used to access resources"
}

variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap, min. 12 characters"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format 0.0.0)"
  default     = "2.4.3"
}
