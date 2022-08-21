<#
.VERSION 1.0
.AUTHOR stephen.tulp@insight.com
.COMPANYNAME Insight

.RELEASENOTES
August 12, 2021 1.0   
    - Initial script

  .DESCRIPTION
    This script deploys all the Azure Policy Definitions to the Root Management Group, use this if you want to only deploy this component only.
#>

# Parameters

$ESLZPrefix = "sjt"
$Location = "australiaeast"
$DeploymentName = "policyDefinitions"

New-AzManagementGroupDeployment -Name "$($ESLZPrefix)-$($DeploymentName)-$($Location)" `
  -ManagementGroupId $ESLZPrefix `
  -Location $Location `
  -TemplateFile ..\managementGroupTemplates\policyDefinitions\policies.json `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -Verbose
