##############################################################################
# Outputs
##############################################################################

output "account_id" {
  description = "Account ID of the watsonx.data instance."
  value       = module.watsonx_data.account_id
}

output "crn" {
  description = "The CRN of the watsonx.data instance."
  value       = module.watsonx_data.crn
}

output "guid" {
  description = "The GUID of the watsonx.data instance."
  value       = module.watsonx_data.guid
}

output "name" {
  description = "The name of the watsonx.data instance."
  value       = module.watsonx_data.name
}

output "plan_id" {
  description = "The plan ID of the watsonx.data instance."
  value       = module.watsonx_data.plan_id
}

output "dashboard_url" {
  description = "The dashboard URL of the watsonx.data instance."
  value       = module.watsonx_data.dashboard_url
}
