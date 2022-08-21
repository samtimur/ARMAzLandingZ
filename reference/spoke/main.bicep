targetScope = 'subscription'

// ---- Landing Zone Parameters ----
@minLength(2)
@maxLength(5)
@description('Specifies the Landing Zone prefix for all resources created in this deployment.')
param lzPrefix string

@description('Specifies the location for all resources.')
param location string

@allowed([
  'dev'
  'tst'
  'prd'
])
@description('Specifies the environment of the deployment.')
param envPrefix string

@description('Specifies the resource prefixes for the deployment.')
param prefixes object = {}

@description('Specifies the tags that you want to apply to all resources.')
param tags object = {}

@description('Specifies the network settings for the Landing Zone.')
param network array = []

@description('Specifies the budget settings for the Landing Zone')
param budgets array = []

// ---- Variables ----
var locPrefix = replace(location, 'australiaeast', 'syd')
var namePrefix = toLower('${lzPrefix}-${locPrefix}-${envPrefix}')
var argName = toLower('${namePrefix}-${prefixes.resourceGroup}')
var nsgName = toLower('${namePrefix}-${prefixes.networkSecurityGroup}')
var vntName = toLower('${namePrefix}-${prefixes.virtualNetwork}')
var udrName = toLower('${namePrefix}-${prefixes.routeTable}')
var akvName = toLower('${namePrefix}-${prefixes.keyVault}')
var rsvName = toLower('${namePrefix}-${prefixes.recoveryVault}')
var tagsDefault = {
  applicationName: 'notset'
  owner: 'notset'
  businessCriticality: 'notset'
  ownerEmail: 'notset'
  costCenter: 'notset'
  dataClassification: 'notset'
}
var tagsJoined = union(tagsDefault, tags)

resource subscriptionTags 'Microsoft.Resources/tags@2021-04-01' = {
  name: 'default'
  properties: {
    tags: {
      environment: 'dev'
      owner: 'tulpy'
      costCenter: '1234'
    }
  }
}

// ---- Landing Zone Resource Groups ----
// Network Resources RG
resource networkResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${argName}-network'
  location: location
  tags: tagsJoined
  properties: {}
}

// Network Watcher Resources RG
resource networkWatcherResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'NetworkWatcherRG'
  location: location
  tags: tagsJoined
  properties: {}
}

// Management Resources RG
resource managementResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${argName}-management'
  location: location
  tags: tagsJoined
  properties: {}
}

// ---- Landing Zone Modules ----
// Network Resources
module networkServices 'modules/network.bicep' = [for (nw, index) in network: {
  name: 'networkServices-${index}'
  scope: networkResourceGroup
  params: {
    location: location
    tags: tagsJoined
    nsgName: nsgName
    vntName: vntName
    udrName: udrName
    vnetAddressPrefix: nw.vnetAddressPrefix
    firewallPrivateIp: nw.firewallPrivateIp
    dnsServerAddresses: nw.dnsServerAddresses
    subnetArray: nw.subnetArray
    hubVnetId: nw.hubVnetId
  }
}]

// Network Watcher Resources
module networkWatcher 'modules/networkWatcher.bicep' = {
  name: 'networkWatcher'
  scope: networkWatcherResourceGroup
  params: {
    location: location
    tags: tagsJoined
    name: ('networkWatcher-${location}')
  }
}

// Storage Resources
module storageServices 'modules/storage.bicep' = {
  name: 'storageServices'
  scope: managementResourceGroup
  params: {
    location: location
    storagePrefix: lzPrefix
    tags: tagsJoined
  }
}

// Key Vault Resources
module keyVaultServices 'modules/keyvault.bicep' = {
  name: 'keyVaultServices'
  scope: managementResourceGroup
  params: {
    location: location
    namePrefix: namePrefix
    akvName: akvName
    tags: tagsJoined
  }
}

// Recovery Services Vault Resources
module recoveryVaultServices 'modules/recoveryVault.bicep' = {
  name: 'recoveryVaultServices'
  scope: managementResourceGroup
  params: {
    location: location
    rsvName: rsvName
    tags: tagsJoined
  }
}

// Azure Budget Resources
module budgetServices 'modules/budgets.bicep' = [for (bg, index) in budgets: {
  name: 'budgetServices-${index}'
  scope: subscription()
  params: {
    amount: bg.amount
    timeGrain: bg.timeGrain
    firstThreshold: bg.firstThreshold
    secondThreshold: bg.secondThreshold
    contactEmails: bg.contactEmails
    contactRoles: bg.contactRoles
  }
}]

// ---- Outputs ----
output managementResourceGroup string = managementResourceGroup.name
output networkWatcherResourceGroup string = networkWatcherResourceGroup.name
output networkResourceGroup string = networkResourceGroup.name
output tags object = tags
