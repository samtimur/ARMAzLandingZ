<#
.VERSION 1.0
.AUTHOR stephen.tulp@insight.com
.COMPANYNAME Insight

.RELEASENOTES
August 12, 2021 1.0   
    - Initial script

  .DESCRIPTION
    This script deploys all the Azure Policy Assignments, use this if you want to only deploy this component only.
#>

# Parameters

$ESLZPrefix = "sjt"
$Location = "australiaeast"
$DeploymentName = "policyAssignment"

# Assign Azure Policy to enforce Log Analytics workspace on the management, , deployed to the Platform Management MG.

New-AzManagementGroupDeployment -Name "$($DeploymentName)-logAnalytics" `
  -Location $Location `
  -TemplateFile .\eslzArm\managementGroupTemplates\policyAssignments\dine-logAnalyticsPolicyAssignment.json `
  -retentionInDays "30" `
  -rgName "$($ESLZPrefix)-mgmt" `
  -ManagementGroupId "$($eslzPrefix)-management" `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -logAnalyticsWorkspaceName "" `
  -workspaceRegion $Location `
  -automationAccountName "" `
  -automationRegion $Location `
  -Verbose

# Assign Azure Policy to enforce Activity Logs to Log Analytics Workspace, deployed to top level MG.

New-AzManagementGroupDeployment -Name "$($DeploymentName)-activityLogsLa" `
  -Location $Location `
  -TemplateFile .\eslzArm\managementGroupTemplates\policyAssignments\dine-activityLogPolicyAssignment.json `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -logAnalyticsResourceId "" `
  -ManagementGroupId $ESLZPrefix `
  -Verbose

# Assign Azure Policy to enforce Activity Logs to Azure Storage Account, deployed to top level MG.

New-AzManagementGroupDeployment -Name "$($DeploymentName)--activityLogsSta" `
  -Location $Location `
  -TemplateFile .\eslzArm\managementGroupTemplates\policyAssignments\dine-activityLogStoragePolicyAssignment.json `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -storageAccountResourceId "" `
  -ManagementGroupId $ESLZPrefix `
  -Verbose


# Assign Azure Policy to enforce Resource Logs to Log Analytics Workspace, deployed to top level MG.

New-AzManagementGroupDeployment -Name "$($DeploymentName)-resourceDiagnostics" `
  -Location $Location `
  -TemplateFile .\eslzArm\managementGroupTemplates\policyAssignments\dine-activityLogPolicyAssignment.json `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -logAnalyticsResourceId "" `
  -ManagementGroupId $ESLZPrefix `
  -Verbose

# Assign Azure Policy to enforce Azure Security Center configuration enabled on all subscriptions, deployed to top level MG.

New-AzManagementGroupDeployment -Name "$($DeploymentName)-ascConfig" `
  -Location $Location `
  -TemplateFile .\eslzArm\managementGroupTemplates\policyAssignments\dine-ascConfigPolicyAssignment.json `
  -ManagementGroupId $eslzPrefix `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -logAnalyticsResourceId "" `
  -emailContactAsc "" `
  -enableAscForServers "Standard" `
  -enableAscForSql "Standard" `
  -enableAscForAppServices "Standard" `
  -enableAscForStorage "Standard" `
  -enableAscForRegistries "Standard" `
  -enableAscForKeyVault "Standard" `
  -enableAscForSqlOnVm "Standard" `
  -enableAscForKubernetes "Standard" `
  -enableAscForArm "Standard" `
  -enableAscForDns "Standard" `
  -enableAscForOsrdb "Standard" `
  -Verbose

# Assign Azure Policy to enable ISO 27001, deployed to top level MG.

New-AzManagementGroupDeployment -Name "$($DeploymentName)-iso27001" `
  -Location $Location `
  -TemplateFile .\eslzArm\managementGroupTemplates\policyAssignments\audit-iso27001-2013PolicyAssignment.json `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -ManagementGroupId $ESLZPrefix `
  -Verbose

# Assign Azure Policy to enable Azure CIS benchmark, deployed to top level MG.

New-AzManagementGroupDeployment -Name "$($DeploymentName)-azureCIS" `
  -Location $Location `
  -TemplateFile .\eslzArm\managementGroupTemplates\policyAssignments\audit-azureCisPolicyAssignment.json `
  -ManagementGroupId $ESLZPrefix `
  -Verbose

# Assign Azure Policy for ensuring Application Gateway should be deployed with WAF, deployed to top level MG.

New-AzManagementGroupDeployment -Name "$($DeploymentName)-deny-appgwy-without-waf" `
  -Location $Location `
  -TemplateFile .\eslzArm\managementGroupTemplates\policyAssignments\deny-appGwyWafPolicyAssignment.json `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -ManagementGroupId $ESLZPrefix `
  -Verbose
  
# Assign Azure Policy for deploying a default budget for a Subscription, deployed to top level MG.

New-AzManagementGroupDeployment -Name "$($DeploymentName)-default-budget" `
  -Location $Location `
  -TemplateFile .\eslzArm\managementGroupTemplates\policyAssignments\dine-azureBudgetPolicyAssignment.json `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -ManagementGroupId $ESLZPrefix `
  -Verbose

# Assign Azure Policy for deploying a flow log resource on a NSG, deployed to top level MG.

New-AzManagementGroupDeployment -Name "$($DeploymentName)-flowLogs" `
  -Location $Location `
  -TemplateFile .\eslzArm\managementGroupTemplates\policyAssignments\dine-nsgFlowLogsPolicyAssignment.json `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -ManagementGroupId $ESLZPrefix `
  -nsgRegion $Location `
  -storageAccountResourceId "" `
  -rgName "" `
  -networkWatcher "" `
  -Verbose

# Assign Azure Policy for enabling Azure Monitor for VMs, deployed to top level MG.

New-AzManagementGroupDeployment -Name "$($DeploymentName)-azMonitorVM" `
  -Location $Location `
  -TemplateFile .\eslzArm\managementGroupTemplates\policyAssignments\dine-vmMonitoringPolicyAssignment.json `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -logAnalyticsResourceId "" `
  -ManagementGroupId $ESLZPrefix `
  -Verbose

# Assign Azure Policy for enabling Azure Monitor for VMSS, deployed to top level MG.

New-AzManagementGroupDeployment -Name "$($DeploymentName)-azMonitorVMSS" `
  -Location $Location `
  -TemplateFile .\eslzArm\managementGroupTemplates\policyAssignments\dine-vmssMonitoringPolicyAssignment.json `
  -topLevelManagementGroupPrefix $ESLZPrefix `
  -logAnalyticsResourceId "" `
  -ManagementGroupId $ESLZPrefix `
  -Verbose
