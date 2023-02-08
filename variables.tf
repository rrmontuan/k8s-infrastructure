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
