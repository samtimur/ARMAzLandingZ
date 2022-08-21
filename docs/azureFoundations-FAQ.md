## FAQ

This page will list frequently asked question for the Azure Foundations architecture

### Azure Foundations Design

**What does "Landing Zone" map to in Azure in the context of Azure Foundations?**

From an Azure Foundations point of view, Subscription is the "Landing Zone" in Azure.

### Reference implementation

**Why do the ARM templates require permission at Tenant root '/' scope?**

Management Group creation, Subscription creation, and Subscription placement into Management Groups are Tenant level PUT API and hence it is pre-requisite to grant permission at root scope to use example templates, which will handle end-2-end Resource composition and orchestration.
