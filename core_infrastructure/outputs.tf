output "subnet_ids" {
  value = module.network.subnet_id_list
  description = "The subnet IDs created in the core infrastructure module"
}