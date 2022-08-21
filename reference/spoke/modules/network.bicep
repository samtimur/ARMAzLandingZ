targetScope = 'resourceGroup'

// Landing Zone Network Parameters

@description('Specifies the location for all resources.')
param location string

@description('Specifies the tags that you want to apply to all resources.')
param tags object

@description('Specifies the NSG prefix of the deployment.')
param nsgName string

@description('Specifies the Virtual Network prefix of the deployment.')
param vntName string

@description('Specifies the Route Table prefix of the deployment.')
param udrName string

@description('Specifies the IP address of the central firewall.')
param firewallPrivateIp string

@description('Specifies the IP addresses of the dns servers.')
param dnsServerAddresses array

@description('Specifies the resource Id of the vnet in the Platform Connectivity Hub Subscription.')
param hubVnetId string

@description('Specifies the address space of the vnet of the Landing Zone.')
param vnetAddressPrefix string

@description('Specifies the List of Subnets and its Address space')
param subnetArray array

@allowed([
  'Yes'
  'No'
])
@description('Optional. Boolean for Resource Lock.')
param resourceLock string = 'Yes'

// Variables
var vnetAddressSpace = substring(vnetAddressPrefix, 0, (length(vnetAddressPrefix) - 3))
var routeTableName = '${udrName}-${uniqueString(resourceGroup().id)}'
var platformConnectivityVnetSubscriptionId = length(split(hubVnetId, '/')) >= 9 ? split(hubVnetId, '/')[2] : subscription().subscriptionId
var platformConnectivityVnetResourceGroupName = length(split(hubVnetId, '/')) >= 9 ? split(hubVnetId, '/')[4] : resourceGroup().name
var platformConnectivityVnetName = length(split(hubVnetId, '/')) >= 9 ? last(split(hubVnetId, '/')) : 'incorrectSegmentLength'

// Creation of the Azure Route Table for the Landing Zone
resource routeTable 'Microsoft.Network/routeTables@2020-11-01' = {
  name: routeTableName
  location: location
  tags: tags
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'FROM-subnet-TO-default-0.0.0.0-0'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallPrivateIp
        }
      }
    ]
  }
}

// Creation of the Network Security Group for the Landing Zone
// Processing subnet as Array from Vnet Array
resource nsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = [for subnet in subnetArray: {
  name: ('${nsgName}-${subnet.name}')
  location: location
  tags: tags
  properties: {
    securityRules: []
  }
}]

// Creation of Azure Virtual Networking for the Landing Zone
// Processing subnets as Array from Vnet Array
resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: ('${vntName}-${vnetAddressSpace}')
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: dnsServerAddresses
    }
    enableDdosProtection: false
    subnets: [for (subnet, index) in subnetArray: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        addressPrefixes: []
        networkSecurityGroup: {
          id: nsg[index].id
        }
        routeTable: {
          id: routeTable.id
        }
        delegations: []
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Disabled'
        serviceEndpointPolicies: []
        serviceEndpoints: []
      }
    }]
  }
}

resource spokeToHubVnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = if (!empty(hubVnetId)) {
  name: '${vnet.name}/FROM-${vnet.name}-TO-${platformConnectivityVnetName}'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: hubVnetId
    }
    useRemoteGateways: false
  }
}

module hubToSpokeVnetPeering 'auxiliary/vnetPeering.bicep' = if (!empty(hubVnetId)) {
  name: 'FROM-${platformConnectivityVnetName}-TO-${vnet.name}'
  scope: resourceGroup(platformConnectivityVnetSubscriptionId, platformConnectivityVnetResourceGroupName)
  params: {
    landingZoneVnetId: vnet.id
    hubVnetId: hubVnetId
  }
}

resource lockResource 'Microsoft.Authorization/locks@2016-09-01' = if (!empty(resourceLock)) {
  name: '${vnet.name}-DontDelete'
  scope: vnet
  dependsOn: [
    vnet
  ]
  properties: {
    level: 'CanNotDelete'
  }
}

// Outputs
output vNetResourceGroup string = resourceGroup().name
output vNetName string = vnet.name
output vNetResourceId string = vnet.id
output nsgIds array = [for (subnetName, index) in subnetArray: {
  name: nsg[index].name
  resourceId: nsg[index].id
}]
output routeTable string = routeTableName
