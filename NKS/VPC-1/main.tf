#####################################################################
# NAVER Cloud Platform
#####################################################################

# ncp cloud provider
provider "ncloud" {
    support_vpc = true
    region      = var.ncp_region
    access_key  = var.ncp_access_key
    secret_key  = var.ncp_secret_key
}


# vpc resource
resource "ncloud_vpc" "ncp_vpc_001" {
  name            = var.vpc_name
  ipv4_cidr_block = var.vpc_cidr_block
}


#cluster Subnet
resource "ncloud_subnet" "cluster_subnet_01_private" {
  name           = "${var.vpc_name}-cluster" # ${} = formating
  vpc_no         = ncloud_vpc.ncp_vpc_001.vpc_no # provider.resoruce_subject.variable
  subnet         = cidrsubnet(ncloud_vpc.ncp_vpc_001.ipv4_cidr_block, 8, 1) # 10.0.1.0/24
                  # cidrsubnet() is terrafrom function(python = def, java = function)
  zone           = var.ncp_zone
  network_acl_no = ncloud_network_acl.nacl.id
  subnet_type    = "PRIVATE" #  PUBLIC(Public) | PRIVATE(Private)
  usage_type     = "GEN" # GEN(General) | LOADB(For load balancer)
}

#public subnet resoruce도 동일하다.


#cluster lb subnet
resource "ncloud_subnet" "cluster_subnet_01_private_lb" {
  name           = "${var.vpc_name}-cluster-lb" 
  vpc_no         =  ncloud_vpc.ncp_vpc_001.vpc_no 
  subnet         = cidrsubnet(ncloud_vpc.ncp_vpc_001.ipv4_cidr_block, 8, 2) # 10.0.2.0/24
  zone           = var.ncp_zone
  network_acl_no = ncloud_network_acl.nacl.id
  subnet_type    = "PRIVATE"
  usage_type     = "LOADB"
}


# nat gateway
resource "ncloud_nat_gateway" "nat_gateway" {
  vpc_no      =  ncloud_vpc.ncp_vpc_001.id
  zone        = var.ncp_zone
  name        = "${var.vpc_name}-k8s-cluster-nat-gw"
}

# network acl
resource "ncloud_network_acl" "nacl" {
   vpc_no      = ncloud_vpc.ncp_vpc_001.id
 }

# private default route data
data "ncloud_route_table" "selected" {
  vpc_no                = ncloud_vpc.ncp_vpc_001.id
  supported_subnet_type = "PRIVATE"
  name = "${var.vpc_name}-default-private-table"
}

# private default route add resource helm down 
resource "ncloud_route" "default_route_natgateway" {
  route_table_no         = data.ncloud_route_table.selected.id
  destination_cidr_block = "0.0.0.0/0"
  target_type            = "NATGW"
  target_name            = ncloud_nat_gateway.nat_gateway.name
  target_no              = ncloud_nat_gateway.nat_gateway.id
}