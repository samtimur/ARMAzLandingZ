targetScope = 'resourceGroup'

// Parameters
param location string
param name string
param tags object

@allowed([
  'Yes'
  'No'
])
@description('Optional. Boolean for Resource Lock.')
param resourceLock string = 'Yes'

// Creation of the Network Watcher for the Landing Zone
resource networkWatcher 'Microsoft.Network/networkWatchers@2020-05-01' = {
  name: name
  location: location
  tags: tags
}

resource lockResource 'Microsoft.Authorization/locks@2016-09-01' = if (!empty(resourceLock)) {
  name: '${networkWatcher.name}-DontDelete'
  scope: networkWatcher
  dependsOn: [
    networkWatcher
  ]
  properties: {
    level: 'CanNotDelete'
  }
}

// Outputs
output networkWatcherResourceGroup string = resourceGroup().name
output networkWatcherName string = networkWatcher.name
output networkWatcherResourceId string = networkWatcher.id
