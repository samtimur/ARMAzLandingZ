targetScope = 'resourceGroup'

// Landing Zone Network Parameters

@description('Optional. Location for all resources.')
param location string

@description('Specifies the tags that you want to apply to all resources.')
param tags object

@description('Specifies the RSV prefix of the deployment.')
param rsvName string

@allowed([
	'GeoRedundant'
	'LocallyRedundant'
])
@description('Backup Vault Replication Type. If not provided, Azure Creates a GRS Vault by default, can be overwritten using the backupstorageconfig API to become LRS. This value cannot change if workloads are added to the backup vault')
param StorageModelType string = 'LocallyRedundant'

// Variables
var recoveryVaultName = '${rsvName}-${uniqueString(resourceGroup().id)}'

resource recoveryVault 'Microsoft.RecoveryServices/vaults@2020-10-01' = {
	name: recoveryVaultName
	location: location
  tags: tags
	sku: {
		name: 'RS0'
		tier: 'Standard'
	}
	properties: {}
}

resource vaultstorageconfig 'Microsoft.RecoveryServices/vaults/backupstorageconfig@2016-12-01' = {
	name: '${recoveryVaultName}/vaultstorageconfig'
	properties: {
		storageModelType: StorageModelType
	}
	dependsOn: [
		recoveryVault
	]
}

output recoveryServicesVaultResourceGroup string = resourceGroup().name
output recoveryServicesVaultName string = recoveryVaultName
output recoveryServicesVaultResourceId string = recoveryVault.id
