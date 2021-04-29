#####################################################################
# Variables
#####################################################################

variable "ncp_region" {
  description = "ncp_region_select"
  default     = "KR"
  type        = string
}

variable "ncp_access_key" {
  description = "ncp_access_key"
  default     = "ncp_access_key"
  type        = string
}

variable "ncp_secret_key" {
  description = "ncp_secret_key"
  default     = "ncp_secret_key"
  type        = string
}

variable "ncp_zone" {
  description = "ncp_zone_select"
  default     = "KR-1"
  type        = string
}

variable "vpc_name" {
  description = "vpc_name"
  default = "ncp-vpc-002"
  type = string
}

variable "vpc_cidr_block"{
  description = "vpc_cidr_block"
  default = "10.0.0.0/16"
  type = string
}



