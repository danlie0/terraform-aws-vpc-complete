output "ec2_api-svr_id" {
  description = "The ID of the instance"
  value       = module.ec2_instance_api-svr.id
}

output "ec2_rpa_agt_id" {
  description = "The ID of the instance"
  value       = module.ec2_instance_rpa-agt-svr.id
}

output "ec2_rpa_svr_id" {
  description = "The ID of the instance"
  value       = module.ec2_instance_rpa-svr-svr.id
}