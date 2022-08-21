targetScope = 'managementGroup'

@description('Provide the ID of the management group that you want to move the subscription to.')
param targetManagementGroupId string

@description('Provide the ID of the existing subscription to move.')
param subscriptionId string

resource subToMG 'Microsoft.Management/managementGroups/subscriptions@2020-05-01' = {
  scope: tenant()
  name: '${targetManagementGroupId}/${subscriptionId}'
}
