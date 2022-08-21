#Use a filter to select resource groups by substring
$filter = 'sjj'
 
#Find Resource Groups by Filter -> Verify Selection
#Get-AzResourceGroup | Where-Object ResourceGroupName -match $filter | Select-Object ResourceGroupName

#Async Delete ResourceGroups by Filter. Uncomment the following line when you are sure. :-)
Get-AzResourceGroup | Where-Object ResourceGroupName -match $filter | Remove-AzResourceGroup -AsJob -Force