@minLength(1)
@description('Resource group to deploy solution resources')
param location string = resourceGroup().location

@description('Workspace name for Log Analytics where Sentinel is setup')
param workspaceName string

@description('The kind of data connectors to enable')
param dataConnectorsKind array = []

@description('The unique guid for this scheduled alert rule')
param ruleGuid string = newGuid()
param enableFusionAlert bool = false
param enableMicrosoftAlerts bool = false
param enableMLAlerts bool = false

var ascRuleId = 'asc${uniqueString(ruleGuid)}'
var mcasRuleId = 'mcas${uniqueString(ruleGuid)}'
var aatpRuleId = 'aatp${uniqueString(ruleGuid)}'
var mdatpRuleId = 'mdatp${uniqueString(ruleGuid)}'
var aadipRuleId = 'aadip${uniqueString(ruleGuid)}'
var o365RuleId = 'o365${uniqueString(ruleGuid)}'
var fusionRuleId = 'fusion${uniqueString(ruleGuid)}'
var mlbaSshRuleId = 'mlSsh${uniqueString(ruleGuid)}'
var mlbaRdpRuleId = 'mlRdp${uniqueString(ruleGuid)}'

resource securityInsightsAadipRuleId 'Microsoft.Insights/alertRules@2016-03-01' = if (contains(dataConnectorsKind, 'AzureActiveDirectory') && enableMicrosoftAlerts) {
  name: aadipRuleId
  kind: 'MicrosoftSecurityIncidentCreation'
  location: location
  properties: {
    alertRuleTemplateName: '532c1811-79ee-4d9f-8d4d-6304c840daa1'
    description: 'Create incidents based on Azure Active Directory Identity Protection alerts'
    displayName: 'Create incidents based on all alerts generated in Azure Active Directory Identity Protection'
    enabled: true
    productFilter: 'Azure Active Directory Identity Protection'
  }
  dependsOn: []
}

resource securityInsightsAscRuleId 'Microsoft.OperationalInsights/workspaces/providers/alertRules@2020-01-01' = if (contains(dataConnectorsKind, 'AzureSecurityCenter') && enableMicrosoftAlerts) {
  name: '${workspaceName}/Microsoft.SecurityInsights/${ascRuleId}'
  kind: 'MicrosoftSecurityIncidentCreation'
  location: location
  properties: {
    alertRuleTemplateName: '90586451-7ba8-4c1e-9904-7d1b7c3cc4d6'
    description: 'Create incidents based on Azure Security Center alerts'
    displayName: 'Create incidents based on all alerts generated in Azure Security Center'
    enabled: true
    productFilter: 'Azure Security Center'
  }
  dependsOn: []
}

resource securityInsightsAatpRuleId 'Microsoft.OperationalInsights/workspaces/providers/alertRules@2020-01-01' = if (contains(dataConnectorsKind, 'AzureAdvancedThreatProtection') && enableMicrosoftAlerts) {
  name: '${workspaceName}/Microsoft.SecurityInsights/${aatpRuleId}'
  kind: 'MicrosoftSecurityIncidentCreation'
  location: location
  properties: {
    alertRuleTemplateName: '40ba9493-4183-4eee-974f-87fe39c8f267'
    description: 'Create incidents based on Azure Advanced Threat Protection alerts'
    displayName: 'Create incidents based on all alerts generated in Azure Advanced Threat Protection'
    enabled: true
    productFilter: 'Azure Advanced Threat Protection'
  }
  dependsOn: []
}

resource securityInsightsMcasRuleId 'Microsoft.OperationalInsights/workspaces/providers/alertRules@2020-01-01' = if (contains(dataConnectorsKind, 'MicrosoftCloudAppSecurity') && enableMicrosoftAlerts) {
  name: '${workspaceName}/Microsoft.SecurityInsights/${mcasRuleId}'
  kind: 'MicrosoftSecurityIncidentCreation'
  location: location
  properties: {
    alertRuleTemplateName: 'b3cfc7c0-092c-481c-a55b-34a3979758cb'
    description: 'Create incidents based on Microsoft Cloud App Security alerts'
    displayName: 'Create incidents based on all alerts generated in Microsoft Cloud App Security'
    enabled: true
    productFilter: 'Microsoft Cloud App Security'
  }
  dependsOn: []
}

resource securityInsightsO365RuleId 'Microsoft.OperationalInsights/workspaces/providers/alertRules@2020-01-01' = if (contains(dataConnectorsKind, 'Office365') && enableMicrosoftAlerts) {
  name: '${workspaceName}/Microsoft.SecurityInsights/${o365RuleId}'
  kind: 'MicrosoftSecurityIncidentCreation'
  location: location
  properties: {
    alertRuleTemplateName: 'ee1d718b-9ed9-4a71-90cd-a483a4f008df'
    description: 'Create incidents based on all alerts generated in Office 365 Advanced Threat Protection'
    displayName: 'Create incidents based on Office 365 Advanced Threat Protection alerts'
    enabled: true
    productFilter: 'Office 365 Advanced Threat Protection'
  }
  dependsOn: []
}

resource securityInsightsMdatpRuleId 'Microsoft.OperationalInsights/workspaces/providers/alertRules@2020-01-01' = if (contains(dataConnectorsKind, 'MicrosoftDefenderAdvancedThreatProtection') && enableMicrosoftAlerts) {
  name: '${workspaceName}/Microsoft.SecurityInsights/${mdatpRuleId}'
  kind: 'MicrosoftSecurityIncidentCreation'
  location: location
  properties: {
    alertRuleTemplateName: '327cd4ed-ca42-454b-887c-54e1c91363c6'
    description: 'Create incidents based on Microsoft Defender Advanced Threat Protection alerts'
    displayName: 'Create incidents based on all alerts generated in Microsoft Defender Advanced Threat Protection'
    enabled: true
    productFilter: 'Microsoft Defender Advanced Threat Protection'
  }
  dependsOn: []
}

resource securityInsightsMlbaSshRuleId 'Microsoft.OperationalInsights/workspaces/providers/alertRules@2020-01-01' = if (contains(dataConnectorsKind, 'Syslog') && enableMLAlerts) {
  name: '${workspaceName}/Microsoft.SecurityInsights/${mlbaSshRuleId}'
  kind: 'MLBehaviorAnalytics'
  location: location
  properties: {
    enabled: true
    alertRuleTemplateName: 'fa118b98-de46-4e94-87f9-8e6d5060b60b'
  }
  dependsOn: []
}

resource securityInsightsMlbaRdpRuleId 'Microsoft.OperationalInsights/workspaces/providers/alertRules@2020-01-01' = if (contains(dataConnectorsKind, 'SecurityEvents') && enableMLAlerts) {
  name: '${workspaceName}/Microsoft.SecurityInsights/${mlbaRdpRuleId}'
  kind: 'MLBehaviorAnalytics'
  location: location
  properties: {
    enabled: true
    alertRuleTemplateName: '737a2ce1-70a3-4968-9e90-3e6aca836abf'
  }
  dependsOn: []
}

resource securityInsightsFusionRuleId 'Microsoft.OperationalInsights/workspaces/providers/alertRules@2020-01-01' = if (enableFusionAlert) {
  name: '${workspaceName}/Microsoft.SecurityInsights/${fusionRuleId}'
  kind: 'Fusion'
  location: location
  properties: {
    enabled: true
    alertRuleTemplateName: 'f71aba3d-28fb-450b-b192-4e76a83015c8'
  }
  dependsOn: []
}

output ruleId string = ruleGuid
