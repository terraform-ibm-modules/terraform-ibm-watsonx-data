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

output "next_steps_text" {
  value       = "You can now use watsonx.data to integrate and analyze all your data through a single, unified data platform."
  description = "Next steps text"
}

output "next_step_primary_label" {
  value       = "Go to the watsonx.data dashboard"
  description = "Primary label"
}

output "next_step_primary_url" {
  value       = module.watsonx_data.dashboard_url
  description = "Primary URL"
}

output "next_step_secondary_label" {
  value       = "Learn more about watsonx.data"
  description = "Secondary label"
}

output "next_step_secondary_url" {
  value       = "https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-wxd_ov"
  description = "Secondary URL"
}
