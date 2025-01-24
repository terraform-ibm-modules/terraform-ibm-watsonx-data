########################################################################################################################
# Outputs
########################################################################################################################

output "account_id" {
  description = "Account ID of the watsonx.data instance."
  value       = local.account_id
}

output "id" {
  description = "ID of the watsonx.data instance."
  value       = local.watsonx_data_id
}

output "crn" {
  description = "The CRN of the watsonx.data instance."
  value       = local.watsonx_data_crn
}

output "guid" {
  description = "The GUID of the watsonx.data instance."
  value       = local.watsonx_data_guid
}

output "name" {
  description = "The name of the watsonx.data instance."
  value       = local.watsonx_data_name
}

output "plan_id" {
  description = "The plan ID of the watsonx.data instance."
  value       = local.watsonx_data_plan_id
}

output "dashboard_url" {
  description = "The dashboard URL of the watsonx.data instance."
  value       = local.watsonx_data_dashboard_url
}
