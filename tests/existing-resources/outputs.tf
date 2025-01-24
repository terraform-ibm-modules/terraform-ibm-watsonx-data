########################################################################################################################
# Outputs
########################################################################################################################

output "account_id" {
  description = "Account ID of the existing watsonx.data instance"
  value       = module.watsonx_data.account_id
}

output "crn" {
  description = "CRN of the existing watsonx.data instance."
  value       = module.watsonx_data.crn
}

output "id" {
  description = "ID of the existing watsonx.data instance."
  value       = module.watsonx_data.id
}

output "dashboard_url" {
  description = "The dashboard URL of the existing watsonx.data instance."
  value       = module.watsonx_data.dashboard_url
}

output "guid" {
  description = "GUID of the existing watsonx.data instance."
  value       = module.watsonx_data.guid
}

output "name" {
  description = "Name of the existing watsonx.data instance."
  value       = module.watsonx_data.name
}

output "plan_id" {
  description = "The plan ID of the existing watsonx.data instance."
  value       = module.watsonx_data.plan_id
}
