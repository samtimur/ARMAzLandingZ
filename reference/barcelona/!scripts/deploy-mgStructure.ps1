<#
.VERSION 1.0
.AUTHOR stephen.tulp@insight.com
.COMPANYNAME Insight

.RELEASENOTES
August 12, 2021 1.0   
    - Initial script

  .DESCRIPTION
    This script deploys the Management Group structure for Enterprise-Scale, use this if you want to only deploy this component only.
#>

# Parameters

$Location = "australiaeast"
$DeploymentName = "mgStructure"
$ESLZPrefix = "sjj"

New-AzTenantDeployment -Name  "$($DeploymentName)-$($Location)" ` `
  -Location $Location `
  -TemplateFile ..\managementGroupTemplates\mgmtGroupStructure\mgmtGroups.json `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -Verbose