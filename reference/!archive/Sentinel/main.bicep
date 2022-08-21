@description('Name for the Log Analytics workspace')
param workspaceName string

@allowed([
  'PerGB2018'
  'Free'
  'Standalone'
  'PerNode'
  'Standard'
  'Premium'
])
@description('Pricing tier: pergb2018 or legacy tiers (Free, Standalone, PerNode, Standard or Premium) which are not available to all customers.')
param pricingTier string

@description('Daily ingestion limit in GBs. This limit doesn\'t apply to the following tables: SecurityAlert, SecurityBaseline, SecurityBaselineSummary, SecurityDetection, SecurityEvent, WindowsFirewall, MaliciousIPCommunication, LinuxAuditLog, SysmonEvent, ProtectionStatus, WindowsEvent')
param dailyQuota int

@minValue(7)
@maxValue(730)
@description('Number of days of retention. Workspaces in the legacy Free pricing tier can only have 7 days.')
param dataRetention int

@description('If set to true when changing retention to 30 days, older data will be immediately deleted. Use this with extreme caution. This only applies when retention is being set to 30 days.')
param immediatePurgeDataOn30Days bool

@allowed([
  'All'
  'Recommended'
  'Minimal'
  'None'
])
@description('Tier for gathering Windows Security Events.')
param securityCollectionTier string

@description('The kind of data connectors that can be deployed via ARM templates are the following: ["AzureActivityLog","SecurityInsightsSecurityEventCollectionConfiguration","WindowsFirewall","DnsAnalytics"], Reference: https://docs.microsoft.com/azure/templates/microsoft.operationalinsights/2020-03-01-preview/workspaces/datasources#microsoftoperationalinsightsworkspacesdatasources-object')
param enableDataConnectorsKind array

@description('Enable MCAS Discovery Logs')
param mcasDiscoveryLogs bool

@description('Location for all resources.')
param location string = resourceGroup().location

var quotaSetting = {
  dailyQuotaGb: dailyQuota
}

// Deploy Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: workspaceName
  location: location
  properties: {
    retentionInDays: dataRetention
    workspaceCapping: ((dailyQuota == 0) ? json('null') : quotaSetting)
    features: {
      immediatePurgeDataOn30Days: immediatePurgeDataOn30Days
    }
    sku: {
      name: pricingTier
    }
  }
}

// Enable Azure Sentinel
resource securityInsights 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'SecurityInsights(${workspaceName})'
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: 'SecurityInsights(${workspaceName})'
    product: 'OMSGallery/SecurityInsights'
    publisher: 'Microsoft'
    promotionCode: ''
  }
}

// Enable Data Connectors
module dataConnectors 'modules/dataConnectors.bicep' = if (!empty(enableDataConnectorsKind)) {
  name: 'enableDataConnectorsKind'
  params: {
    dataConnectorsKind: enableDataConnectorsKind
    workspaceName: workspaceName
    tenantId: subscription().tenantId
    subscriptionId: subscription().subscriptionId
    securityCollectionTier: securityCollectionTier
    mcasDiscoveryLogs: mcasDiscoveryLogs
    location: location
  }
  dependsOn: [
    securityInsights
  ]
}
/*
// Enable Alert Rules
module alertRules 'modules/alertRules.bicep' = if (enableFusionAlert || enableMicrosoftAlerts || enableMLAlerts) {
  name: 'enableAlerts'
  params: {
    dataConnectorsKind: enableDataConnectorsKind
    workspaceName: workspaceName
    location: location
    enableFusionAlert: enableFusionAlert
    enableMicrosoftAlerts: enableMicrosoftAlerts
    enableMLAlerts: enableMLAlerts
  }
  dependsOn: [
    securityInsights
  ]
}

// Enable Scheduled Alerts
module scheduledAlerts 'modules/scheduledAlerts.bicep' = if (enableScheduledAlerts) {
  name: 'enableScheduledAlerts'
  params: {
    workspaceName: workspaceName
    dataConnectorsList: replace(replace(string(enableDataConnectorsKind), '"', ''), '[', '')
  }
  dependsOn: [
    alertRules
  ]
}
*/
// Outputs
output workspaceName string = workspaceName
output workspaceIdOutput string = reference(logAnalyticsWorkspace.id, '2015-11-01-preview').customerId
output workspaceKeyOutput string = listKeys(logAnalyticsWorkspace.id, '2015-11-01-preview').primarySharedKey
output dataConnectorsList string = replace(replace(string(enableDataConnectorsKind), '"', ''), '[', '')
