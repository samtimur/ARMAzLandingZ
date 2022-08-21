
$DeploymentName = 'la'
$SubscriptionId = 'afa561b9-1bcc-4e69-bb33-af606363a7df'
$TenantId = 'a2ebc691-c318-4ec2-998a-a87c528378e0'

Select-AzSubscription -SubscriptionName $SubscriptionId -Tenant $TenantId

New-AzResourceGroupDeployment -Name $DeploymentName `
-ResourceGroupName "arg-syd-platform-mgmt-management" `
-TemplateFile '.\arm-cloudsoe-la-solutions.json' `
-Verbose `
-debug




