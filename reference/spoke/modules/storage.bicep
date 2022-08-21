//param prefix string

@description('Required. Storage Account Prefix.')
param storagePrefix string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
    'StorageV2'
    'BlobStorage'
    'BlockBlobStorage'
])
@description('Optional. Type of Storage Account to create. BlobStorage is available with Standard only, BlockBlobStorage is available with Premium only.')
param storageAccountKind string = 'StorageV2'

@allowed([
    'Standard_LRS'
    'Standard_GRS'
    'Standard_RAGRS'
    'Standard_ZRS'
    'Premium_LRS'
    'Premium_ZRS'
    'Standard_GZRS'
    'Standard_RAGZRS'
])
@description('Optional. Storage Account Sku Name. StorageV2 only support Premium LRS. Blob Storage only supports Standard LRS, GRS, RAGRS. Block Blob Storage supports Premium LRS, ZRS')
param storageAccountSku string = 'Standard_LRS'

@allowed([
    'Hot'
    'Cool'
])
@description('Optional. Storage Account Access Tier.')
param storageAccountAccessTier string = 'Hot'

@description('Optional. If point-in-time restore for Containers is enabled, then versioning, change feed, and blob soft delete must also be enabled.')
param enablePointInTimeRestoreForContainers bool = false

@minValue(1)
@maxValue(364)
@description('Required if point-in-time restore for Containers is enabled. If not provided, the default will be used. This value must be at least 1 and less than the value that is set for blob soft delete.')
param pointInTimeRestoreForContainersRestoreDays int = 6

@description('Optional. If point-in-time restore for Containers is enabled, then blob soft delete must also be enabled and will be overridden within template to and use default values for Blob retention days if not provided (if set to false)')
param enableSoftDeleteForBlobs bool = true

@minValue(1)
@maxValue(365)
@description('Required if enableSoftDeleteForBlobs is enabled. If not provided, the default will be used. This value must be a number between 1 and 365.')
param softDeleteForBlobsRetentionDays int = 7

@description('Optional. Default is True, enables Soft Delete for Containers')
param enableSoftDeleteForContainers bool = true

@minValue(1)
@maxValue(365)
@description('Required if enableSoftDeleteForContainers is enabled. If not provided, the default will be used. This value must be a number between 1 and 365.')
param softDeleteForContainersRetentionDays int = 7

@description('Optional. Default is false. If kept to False, and enablePointInTimeRestoreForContainers is set to True, then it will be overridded within template to True.')
param enableVersioningForBlobs bool = false

@description('Optional. Default is True. If kept to False, and enablePointInTimeRestoreForContainers is set to True, then it will be overrided within template to True.')
param enableBlobChangeFeed bool = false

@allowed([
    'Yes'
    'No'
])
@description('Optional. Boolean for Resource Lock.')
param resourceLock string = 'Yes'

@description('Optional. Tags of the resource.')
param tags object = {}

var storageAccountName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

var restorePolicyEnabled = {
    enabled: enablePointInTimeRestoreForContainers
    days: pointInTimeRestoreForContainersRestoreDays
}
var deleteRetentionPolicyEnabled = {
    enabled: ((enablePointInTimeRestoreForContainers == json('true')) ? json('true') : enableSoftDeleteForBlobs)
    days: softDeleteForBlobsRetentionDays
}
var containerDeleteRetentionPolicyEnabled = {
    enabled: enableSoftDeleteForContainers
    days: softDeleteForContainersRetentionDays
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
    name: toLower('${storageAccountName}')
    location: location
    kind: storageAccountKind
    tags: tags
    sku: {
        name: storageAccountSku
    }
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
        encryption: {
            services: {
                blob: {
                    enabled: true
                }
            }
            keySource: 'Microsoft.Storage'
        }
        accessTier: storageAccountAccessTier
        supportsHttpsTrafficOnly: true
        minimumTlsVersion: 'TLS1_2'
        networkAcls: {
            bypass: 'AzureServices'
            virtualNetworkRules: []
            ipRules: []
            defaultAction: 'Deny'
        }
        allowBlobPublicAccess: false
    }
}

resource storageAccountName_default 'Microsoft.Storage/storageAccounts/blobServices@2019-06-01' = {
    name: '${toLower(storageAccount.name)}/default'
    properties: {
        restorePolicy: ((enablePointInTimeRestoreForContainers == json('true')) ? restorePolicyEnabled : json('null'))
        deleteRetentionPolicy: ((enablePointInTimeRestoreForContainers == json('true')) ? deleteRetentionPolicyEnabled : ((enableSoftDeleteForBlobs == json('true')) ? deleteRetentionPolicyEnabled : json('null')))
        containerDeleteRetentionPolicy: ((enableSoftDeleteForContainers == json('true')) ? containerDeleteRetentionPolicyEnabled : json('null'))
        changeFeed: {
            enabled: ((enablePointInTimeRestoreForContainers == json('true')) ? json('true') : enableBlobChangeFeed)
        }
        isVersioningEnabled: ((enablePointInTimeRestoreForContainers == json('true')) ? json('true') : enableVersioningForBlobs)
    }
    dependsOn: [
        storageAccount
    ]
}

resource lockResource 'Microsoft.Authorization/locks@2016-09-01' = if (!empty(resourceLock)) {
    name: '${storageAccount.name}-DontDelete'
    scope: storageAccount
    dependsOn: [
        storageAccount
    ]
    properties: {
        level: 'CanNotDelete'
    }
}

// Outputs
output storageAccountResourceGroup string = resourceGroup().name
output storageAccountName string = toLower(storageAccount.name)
output storageAccountResourceId string = storageAccount.id
