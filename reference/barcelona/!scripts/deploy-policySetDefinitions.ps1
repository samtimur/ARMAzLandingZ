<#
.VERSION 1.0
.AUTHOR stephen.tulp@insight.com
.COMPANYNAME Insight

.RELEASENOTES
August 12, 2021 1.0   
    - Initial script

  .DESCRIPTION
    This script deploys all the Azure Policy Set Definitions to the Root Management Group, use this if you want to only deploy this component only.
#>

# Parameters

$ESLZPrefix = "sjt"
$Location = "australiaeast"
$DeploymentName = "policySetDefinitions"

# Deploying Azure Policy Initiative for associating private DNS zones with private endpoints for Azure PaaS services

New-AzManagementGroupDeployment -Name "$($ESLZPrefix)-$($DeploymentName)-privateDns-$($Location)" `
  -ManagementGroupId $ESLZPrefix `
  -Location $Location `
  -TemplateFile ..\managementGroupTemplates\policyDefinitions\dine-privateDnsZonesPolicySetDefinition.json `
  -Verbose

# Deploying Azure Policy Initiative for Azure Security Center Configuration

New-AzManagementGroupDeployment -Name "$($ESLZPrefix)-$($DeploymentName)-ascConfig-$($Location)" `
  -ManagementGroupId $ESLZPrefix `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -Location $Location `
  -TemplateFile ..\managementGroupTemplates\policyDefinitions\deploy-ascConfigurationPolicySetDefinition.json `
  -Verbose

# Deploy Azure Policy Initiative for preventing usage of public endpoint for Azure PaaS services

New-AzManagementGroupDeployment -Name "$($ESLZPrefix)-$($DeploymentName)-publicEndpoints-$($Location)" `
  -ManagementGroupId $ESLZPrefix `
  -Location $Location `
  -TemplateFile ..\managementGroupTemplates\policyDefinitions\deny-publicEndpointsPolicySetDefinition.json `
  -Verbose

# Deploy Azure Policy Initiative for enforcing TLS and SSL Encryption for Azure PaaS services

New-AzManagementGroupDeployment -Name "$($ESLZPrefix)-$($DeploymentName)-tlsSsl-$($Location)" `
  -ManagementGroupId $ESLZPrefix `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -Location $Location `
  -TemplateFile ..\managementGroupTemplates\policyDefinitions\deny-dine-append-tlsSslPolicySetDefinition.json `
  -Verbose

# Deploy Azure Policy Initiative for enforcing Azure Governance across the environment

New-AzManagementGroupDeployment -Name "$($ESLZPrefix)-$($DeploymentName)-azureGovernance-$($Location)" `
  -ManagementGroupId $ESLZPrefix `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -Location $Location `
  -TemplateFile ..\managementGroupTemplates\policyDefinitions\apply-azureGovernancePolicySetDefinition.json `
  -Verbose
