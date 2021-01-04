module "vpc1" {
  source   = "../../modules/vpc1"
  region   = var.region1
  key_name = var.key_name
  providers = {
    aws = aws.eu-west-1
  }
}

module "vpc2" {
  source   = "../../modules/vpc2"
  region   = var.region2
  key_name = var.key_name
  vpc1_cidr_block = module.vpc1.vpc_cidr_block
  providers = {
    aws = aws.us-west-1
  }
}

module "peer_vpc1_vpc2" {
  source                     = "../../modules/peering"
  requestor_region           = var.region1
  acceptor_region            = var.region2
  requestor_vpc_id           = module.vpc1.vpc_id
  acceptor_vpc_id            = module.vpc2.vpc_id
  requestor_cidr_block       = module.vpc1.vpc_cidr_block
  acceptor_cidr_block        = module.vpc2.vpc_cidr_block
  requestor_route_table_id   = module.vpc1.public_route_table_ids[0]
  acceptor_intra_subnet_id   = module.vpc2.private_subnets[0]
  providers = {
    aws.src = aws.eu-west-1
    aws.dst = aws.us-west-1
  }
}