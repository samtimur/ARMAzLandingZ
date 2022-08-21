<#
.VERSION 1.0
.AUTHOR stephen.tulp@insight.com
.COMPANYNAME Insight

.RELEASENOTES
August 12, 2021 1.0   
    - Initial script

  .DESCRIPTION
    This script deploys the Platform Connectivitiy Components, use this if you want to only deploy this component only.
#>

# Parameters

$ESLZPrefix = "sjj"
$Location = "australiaeast"
$DeploymentName = "platformConnectivity"
$ConnectivitySubscriptionId = "8d0248a2-d875-4407-99a6-0981fe09bff2"
$ConnectivityAddressPrefix = "10.49.0.0/18"


Select-AzSubscription -SubscriptionId $ConnectivitySubscriptionId

New-AzSubscriptionDeployment -Name "$($ESLZPrefix)-$($DeploymentName)-$($Location)" `
    -Location $Location `
    -TemplateFile ..\subscriptionTemplates\hubspokeConnectivity.json `
   # -topLevelManagementGroupPrefix $ESLZPrefix `
    -connectivitySubscriptionId $ConnectivitySubscriptionId `
    -addressPrefix $ConnectivityAddressPrefix `
    -enableHub "vhub" `
    -enableAzFw "No" `
    -enableAzFwDnsProxy "No" `
    -enableVpnGw "No" `
    -enableErGw "No" `
    -enableDdoS "No" `
    -enableAppGw "Yes" `
    -enableAzBastion "No" `
    -Verbose