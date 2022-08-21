<#
.VERSION 1.0
.AUTHOR stephen.tulp@insight.com
.COMPANYNAME Insight

.RELEASENOTES
August 12, 2021 1.0   
    - Initial script

  .DESCRIPTION
    This script deploys the Log Analytics Solutions, use this if you want to only deploy this component only.
#>

# Parameters

$ESLZPrefix = "sjj"
$Location = "australiaeast"
$DeploymentName = "logAnalyticsSolutions"
$ManagementSubscriptionId = "afa561b9-1bcc-4e69-bb33-af606363a7df"
$rgName = "sjj-syd-mgmt-arg-management"
$workspaceName = "sjj-syd-mgmt-law-a74317f"

Select-AzSubscription -SubscriptionName $ManagementSubscriptionId

New-AzSubscriptionDeployment -Name "$($ESLZPrefix)-$($DeploymentName)-$($Location)" `
  -Location $Location `
  -TemplateFile ..\subscriptionTemplates\logAnalyticsSolutions.json `
  -rgName $rgName `
  -workspaceName $workspaceName `
  -workspaceRegion $Location `
  -Verbose