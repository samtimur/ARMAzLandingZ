targetScope = 'resourceGroup'

// Parameters
param hubVnetId string
param landingZoneVnetId string

// Variables
var platformConnectivityVnetName = length(split(hubVnetId, '/')) >= 9 ? last(split(hubVnetId, '/')) : 'incorrectSegmentLength'
var landingZoneVnetName = length(split(landingZoneVnetId, '/')) >= 9 ? last(split(landingZoneVnetId, '/')) : 'incorrectSegmentLength'

// Resources
resource hubToSpokeVnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${platformConnectivityVnetName}/FROM-${platformConnectivityVnetName}-TO-${landingZoneVnetName}'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: landingZoneVnetId
    }
    useRemoteGateways: false
  }
}

// Outputs
