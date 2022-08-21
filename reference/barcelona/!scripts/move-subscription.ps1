<#
.VERSION 1.0
.AUTHOR stephen.tulp@insight.com
.COMPANYNAME Insight

.RELEASENOTES
August 12, 2021 1.0   
    - Initial script

  .DESCRIPTION
    This script moves the associated Platorm Subscription to the appropriate Management Group, use this if you want to only deploy this component only.
#>

# Parameters

$ESLZPrefix = "sjt"
$Location = "australiaeast"
$DeploymentName = "moveSubscription"
$ConnectivitySubscriptionId = "8d0248a2-d875-4407-99a6-0981fe09bff2"
$IdentitySubscriptionId = "8d0248a2-d875-4407-99a6-0981fe09bff2"
$ManagementSubscriptionId = "5cb7efe0-67af-4723-ab35-0f2b42a85839"
$SubscriptionId = ""

# Move Platform Connectivity Subscription

New-AzManagementGroupDeployment -Name "$($ESLZPrefix)-$($DeploymentName)-conn-$($Location)" `
  -ManagementGroupId $ESLZPrefix `
  -Location $Location `
  -TemplateFile ..\managementGroupTemplates\subscriptionOrganization\subscriptionOrganization.json `
  -targetManagementGroupId "$($ESLZPrefix)-connectivity" `
  -subscriptionId $ConnectivitySubscriptionId   `
  -Verbose

  # Move Platform Management Subscription

  New-AzManagementGroupDeployment -Name "$($ESLZPrefix)-$($DeploymentName)-mgmt-$($Location)" `
  -ManagementGroupId $ESLZPrefix `
  -Location $Location `
  -TemplateFile ..\managementGroupTemplates\subscriptionOrganization\subscriptionOrganization.json `
  -targetManagementGroupId "$($ESLZPrefix)-management" `
  -subscriptionId $IdentitySubscriptionId   `
  -Verbose

  # Move Platform Identity Subscription

  New-AzManagementGroupDeployment -Name "$($ESLZPrefix)-$($DeploymentName)-idam-$($Location)" `
  -ManagementGroupId $ESLZPrefix `
  -Location $Location `
  -TemplateFile ..\managementGroupTemplates\subscriptionOrganization\subscriptionOrganization.json `
  -targetManagementGroupId "$($ESLZPrefix)-identity" `
  -subscriptionId $ManagementSubscriptionId   `
  -Verbose

  # Move Subscription

  New-AzManagementGroupDeployment -Name "$($ESLZPrefix)-$($DeploymentName)-$($Location)" `
  -ManagementGroupId $ESLZPrefix `
  -Location $Location `
  -TemplateFile ..\managementGroupTemplates\subscriptionOrganization\subscriptionOrganization.json `
  -targetManagementGroupId "" `
  -subscriptionId $subscriptionId   `
  -Verbose