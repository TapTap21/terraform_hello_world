provider "aws" {
  profile    = var.profile
  region     = var.region
}

module "terra-fargate" {
  source  = "cn-terraform/ecs-fargate/aws"
  version = "2.0.9"
  container_image = "nginxdemos/hello"
  container_name = "webserver"
  container_port = "80"
  name_preffix = var.name_preffix
  profile = var.profile
  container_memory = "512"
  container_memory_reservation = "512"
  container_cpu = "256"
  environment = [{
    name = "TEST_ENV_NAME"
    value = "TEST_ENV_VALUE"
  }]
//  ulimits = [{
//    name = "webserver"
//    hardLimit = 128
//    softLimit = 128
//  }]
  desired_count = 4
  vpc_id              = module.networking.vpc_id
  availability_zones  = module.networking.availability_zones
  public_subnets_ids  = module.networking.public_subnets_ids
  private_subnets_ids = module.networking.private_subnets_ids
  region = var.region
}

module "networking" {
  source          = "cn-terraform/networking/aws"
  version         = "2.0.3"
  profile         = var.profile
  name_preffix    = var.name_preffix
  region          = var.region
  availability_zones = [ "us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d" ]
  private_subnets_cidrs_per_availability_zone = [ "192.168.128.0/19", "192.168.160.0/19", "192.168.192.0/19", "192.168.224.0/19" ]
  public_subnets_cidrs_per_availability_zone = [ "192.168.0.0/19", "192.168.32.0/19", "192.168.64.0/19", "192.168.96.0/19" ]
  vpc_cidr_block = "192.168.0.0/16"
}