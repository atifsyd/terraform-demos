module "network" {
  source = "./network"
}

module "security" {
  source = "./security"
  vpc_id = module.network.vpc
}
