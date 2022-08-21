@description('The kind of data connectors to enable')
param dataConnectorsKind array

@description('Name for the Log Analytics workspace used to aggregate data')
param workspaceName string

@description('SecurityEvent logging level')
param securityCollectionTier string

@description('Azure AD tenant ID')
param tenantId string

@description('Subscription Id to monitor')
param subscriptionId string = subscription().subscriptionId
param mcasDiscoveryLogs bool

@description('Location for all resources.')
param location string = resourceGroup().location

var o365Name = 'o365${uniqueString(resourceGroup().id)}'
var mdatpName = 'mdatp${uniqueString(resourceGroup().id)}'
var aatpName = 'aatp${uniqueString(resourceGroup().id)}'
var ascName = 'asc${uniqueString(resourceGroup().id)}'
var mcasName = 'mcas${uniqueString(resourceGroup().id)}'
var aadipName = 'aadip${uniqueString(resourceGroup().id)}'
var tiName = 'ti${uniqueString(resourceGroup().id)}'

resource securityInsightsO365Name 'Microsoft.SecurityInsights/dataConnectors@2020-01-01' = if (contains(dataConnectorsKind, 'Office365')) {
  name: o365Name
  scope: workspaceSubscriptionId
  kind: 'Office365'
  properties: {
    tenantId: tenantId
    dataTypes: {
      exchange: {
        state: 'Enabled'
      }
      sharePoint: {
        state: 'Enabled'
      }
      teams: {
        state: 'Enabled'
      }
    }
  }
}

resource securityInsightsMdatpName 'Microsoft.SecurityInsights/dataConnectors@2020-01-01' = if (contains(dataConnectorsKind, 'MicrosoftDefenderAdvancedThreatProtection')) {
  //location: location
  name: mdatpName
  scope: workspaceSubscriptionId
  kind: 'MicrosoftDefenderAdvancedThreatProtection'
  properties: {
    tenantId: tenantId
    dataTypes: {
      alerts: {
        state: 'Enabled'
      }
    }
  }
}

resource securityInsightsMcasName 'Microsoft.SecurityInsights/dataConnectors@2020-01-01' = if (contains(dataConnectorsKind, 'MicrosoftCloudAppSecurity')) {
  //location: location
  name: mcasName
  scope: workspaceSubscriptionId
  kind: 'MicrosoftCloudAppSecurity'
  properties: {
    tenantId: tenantId
    dataTypes: {
      alerts: {
        state: 'Enabled'
      }
      discoveryLogs: {
        state: (mcasDiscoveryLogs ? 'Enabled' : 'Disabled')
      }
    }
  }
}

resource securityInsightsAscName 'Microsoft.SecurityInsights/dataConnectors@2020-01-01' = if (contains(dataConnectorsKind, 'AzureSecurityCenter')) {
  //location: location
  name: ascName
  scope: workspaceSubscriptionId
  kind: 'AzureSecurityCenter'
  properties: {
    subscriptionId: subscriptionId
    dataTypes: {
      alerts: {
        state: 'Enabled'
      }
    }
  }
}

resource securityInsightsAatpName 'Microsoft.SecurityInsights/dataConnectors@2020-01-01' = if (contains(dataConnectorsKind, 'AzureAdvancedThreatProtection')) {
  //location: location
  name: aatpName
  scope: workspaceSubscriptionId
  kind: 'AzureAdvancedThreatProtection'
  properties: {
    tenantId: tenantId
    dataTypes: {
      alerts: {
        state: 'Enabled'
      }
    }
  }
}

resource securityInsightsAadipName 'Microsoft.SecurityInsights/dataConnectors@2020-01-01' = if (contains(dataConnectorsKind, 'AzureActiveDirectory')) {
  //location: location
  name: aadipName
  scope: workspaceSubscriptionId
  kind: 'AzureActiveDirectory'
  properties: {
    tenantId: tenantId
    dataTypes: {
      alerts: {
        state: 'Enabled'
      }
    }
  }
}

resource workspaceSubscriptionId 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (contains(dataConnectorsKind, 'AzureActivity')) {
  name: '${workspaceName}/${replace(subscriptionId, '-', '')}'
  kind: 'AzureActivityLog'
  properties: {
    linkedResourceId: '/subscriptions/${subscriptionId}/providers/microsoft.insights/eventtypes/management'
  }
}

resource securityInsightsSecurityEventCollectionConfiguration 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (contains(dataConnectorsKind, 'SecurityEvents')) {
  name: '${workspaceName}/SecurityInsightsSecurityEventCollectionConfiguration'
  kind: 'SecurityInsightsSecurityEventCollectionConfiguration'
  properties: {
    tier: securityCollectionTier
    tierSetMethod: 'Custom'
  }
}

resource windowsFirewall 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = if (contains(dataConnectorsKind, 'WindowsFirewall')) {
  name: 'WindowsFirewall(${workspaceName})'
  location: location
  plan: {
    name: 'WindowsFirewall(${workspaceName})'
    promotionCode: ''
    product: 'OMSGallery/WindowsFirewall'
    publisher: 'Microsoft'
  }
  properties: {
    workspaceResourceId: resourceId('Microsoft.OperationalInsights/workspaces', workspaceName)
    containedResources: []
  }
}

resource dnsAnalytics 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = if (contains(dataConnectorsKind, 'DNS')) {
  name: 'DnsAnalytics(${workspaceName})'
  location: location
  plan: {
    name: 'DnsAnalytics(${workspaceName})'
    promotionCode: ''
    product: 'OMSGallery/DnsAnalytics'
    publisher: 'Microsoft'
  }
  properties: {
    workspaceResourceId: resourceId('Microsoft.OperationalInsights/workspaces', workspaceName)
    containedResources: []
  }
}

resource syslogCollection 'Microsoft.OperationalInsights/workspaces/dataSources@2020-03-01-preview' = if (contains(dataConnectorsKind, 'Syslog')) {
  name: '${workspaceName}/syslogCollection'
  kind: 'LinuxSyslogCollection'
  properties: {
    state: 'Enabled'
  }
}

resource securityInsightsThreatIntelligence 'Microsoft.SecurityInsights/dataConnectors@2020-01-01' = if (contains(dataConnectorsKind, 'ThreatIntelligence')) {
  //location: location
  name: tiName
  scope: workspaceSubscriptionId
  kind: 'ThreatIntelligence'
  properties: {
    tenantId: tenantId
    dataTypes: {
      indicators: {
        state: 'Enabled'
      }
    }
  }
}
