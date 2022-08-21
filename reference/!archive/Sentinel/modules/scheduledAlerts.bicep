@description('Name for the Log Analytics workspace')
param workspaceName string

@description('Comma separated enabled connectors: AzureActivityLog,SecurityEvents,WindowsFirewall,DnsAnalytics. Reference: https://docs.microsoft.com/azure/templates/microsoft.operationalinsights/2020-03-01-preview/workspaces/datasources#microsoftoperationalinsightsworkspacesdatasources-object')
param dataConnectorsList string
param roleGuid string = newGuid()

var managedIdentityName = 'userIdentity${uniqueString(resourceGroup().id)}'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: resourceGroup().location
}

resource sleep 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'sleep'
  location: resourceGroup().location
  kind: 'AzurePowerShell'
  properties: {
    forceUpdateTag: '1'
    azPowerShellVersion: '3.0'
    arguments: ''
    scriptContent: 'Start-Sleep -Seconds 120'
    supportingScriptUris: []
    timeout: 'PT30M'
    cleanupPreference: 'Always'
    retentionInterval: 'P1D'
  }
  dependsOn: [
    managedIdentity
  ]
}

resource roleGuid_resource 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: roleGuid
  //scope: resourceGroup().id
  properties: {
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    principalId: reference(managedIdentity.id, '2018-11-30', 'Full').properties.principalId
    
  }
  dependsOn: [
    sleep
  ]
}

resource runPowerShellInline 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'runPowerShellInline'
  location: resourceGroup().location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    forceUpdateTag: '1'
    azPowerShellVersion: '3.0'
    arguments: '-Workspace ${workspaceName} -ResourceGroup ${resourceGroup().name} -Connectors ${dataConnectorsList}'
    primaryScriptUri: 'https://raw.githubusercontent.com/Azure/Azure-Sentinel/master/Tools/Sentinel-All-In-One/ARMTemplates/Scripts/EnableRules.ps1'
    supportingScriptUris: []
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
  dependsOn: [
    roleGuid_resource
  ]
}
