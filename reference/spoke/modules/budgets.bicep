targetScope = 'subscription'

@description('Required. Specifies the budget amount for the Landing Zone.')
param amount int

@description('Required. Define the starr date for the Budget.')
param startDate string = '${utcNow('MM')}/01/${utcNow('yyyy')}'

@allowed([
  'Monthly'
  'Quarterly'
  'Annually'
])
@description('Required. The time covered by a budget. Tracking of the amount will be reset based on the time grain.')
param timeGrain string

@description('Required. Specifies the budget first theshold % (0-100) for the Landing Zone.')
param firstThreshold int

@description('Required. Specifies the budget second theshold % (0-100) for the Landing Zone.')
param secondThreshold int

@description('Required. Specifies an array of email addresses for the Azure budget.')
param contactEmails array

@description('Required. Specifies an array of Azure Roles (Owner, Contributor) for the Azure budget.')
param contactRoles array

var subscriptionid = subscription().subscriptionId

resource budgets 'Microsoft.Consumption/budgets@2019-10-01' = {
  name: toLower('subscriptionBudget-${subscriptionid}')
  properties: {
    timePeriod: {
      startDate: startDate
    }
    timeGrain: timeGrain
    amount: amount
    category: 'Cost'
    notifications: {
      NotificationForExceededBudget1: {
        enabled: true
        operator: 'GreaterThan'
        threshold: firstThreshold
        contactEmails: contactEmails
        contactRoles: contactRoles
      }
      NotificationForExceededBudget2: {
        enabled: true
        operator: 'GreaterThan'
        threshold: secondThreshold
        contactEmails: contactEmails
        contactRoles: contactRoles
      }
    }
  }
}
