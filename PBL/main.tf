
  #Providers
    provider "aws" {
    region = var.region
    }



# Create VPC
  resource "aws_vpc" "main"{
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support
}


   # Get list of availability zones from AWS
        data "aws_availability_zones" "available" {
        state = "available"
        }
        
  # Create public subnet1
   resource "aws_subnet" "public" {
        count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets 
        vpc_id                  = aws_vpc.main.id
        cidr_block              = cidrsubnet(var.vpc_cidr, 4 , count.index)
        map_public_ip_on_launch = true
        availability_zone       = data.aws_availability_zones.available.names[count.index]

    }

# # Create public subnet2
# resource "aws_subnet" "public2" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "172.16.1.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "us-east-1b"
# }