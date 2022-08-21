<#
.VERSION 1.0
.AUTHOR stephen.tulp@insight.com
.COMPANYNAME Insight

.RELEASENOTES
August 12, 2021 1.0   
    - Initial script

  .DESCRIPTION
    This script sends Azure AD Activity Logs to a Log Analytics workspace.
#>

# Parameters

$Location = "australiaeast"
$DeploymentName = "azureAdActivityLogs"
$lawResourceId = "/subscriptions/afa561b9-1bcc-4e69-bb33-af606363a7df/resourcegroups/sjj-syd-mgmt-arg-management/providers/microsoft.operationalinsights/workspaces/sjj-syd-mgmt-law-a74317f"

New-AzTenantDeployment -Name  "$($DeploymentName)-$($Location)" ` `
  -Location $Location `
  -TemplateFile ..\tenantTemplates\deploy-azureAdActivityLogs.json `
  -lawResourceId $lawResourceId  `
  -Verbose