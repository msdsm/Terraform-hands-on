variable "region" {
  description = "The AWS region your resources will be deployed"
  default     = "us-west-2"
}

variable "profile" {
  description = "profile"
  type        = string
  default     = "msd_user"
}

variable "name" {
  description = "The operator name running this configuration"
}
